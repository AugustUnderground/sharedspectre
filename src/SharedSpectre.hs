{-# OPTIONS_GHC -Wall #-}

{-# LANGUAGE CPP                      #-}
{-# LANGUAGE ForeignFunctionInterface #-}

-- | Exported Functions for Spectre Interaction
module SharedSpectre ( version
                     , simulate
                     , numOfPlots
                     , nameOfPlot
                     , plotByName
                     , plotByIndex
                     , numOfVars
                     , nameOfVar
                     , numOfPoints
                     , waveByName
                     , waveByIndex
                     , isComplex
                     , realData
                     , imagData
                     , startSession
                     , stopSession
                     ) where

import qualified Spectre               as S
import qualified Spectre.Interactive   as SI
import           Data.Complex
import qualified Data.Map              as M
import           Data.Maybe                 (fromJust)
import           Data.NutMeg
import qualified Data.Vector.Unboxed   as V
import           Foreign.C.String
import           Foreign.C.Types
import           Foreign.Ptr
import           Foreign.StablePtr
import           Foreign.Marshal.Array

-- | Get Spectre Version
version :: IO CString
version = S.version >>= newCString

marshal' :: Ptr CString -> CInt -> CString -> IO ([String], String)
marshal' includes len netlist = do
    let len'   = fromInteger $ toInteger len :: Int
    netlist'   <- peekCString netlist
    includes'' <- map peekCString <$> peekArray len' includes
    includes'  <- sequence includes''
    pure (includes', netlist')

-- | Run a Simulation
simulate :: Ptr CString -> CInt -> CString -> IO (StablePtr NutMeg)
simulate includes len netlist = marshal' includes len netlist
                                    >>= uncurry S.simulate
                                    >>= newStablePtr

-- | Launch an interactive session
startSession :: Ptr CString -> CInt -> CString -> IO (StablePtr SI.Session)
startSession includes len netlist = marshal' includes len netlist
                                        >>= uncurry SI.initSession
                                        >>= newStablePtr

-- | Quit Spectre Interactive Session
stopSession :: StablePtr SI.Session -> IO ()
stopSession session = deRefStablePtr session >>= SI.exitSession 

-- | Number of Plots in the nutmeg object
numOfPlots :: StablePtr NutMeg -> IO CInt
numOfPlots nut = do
    nut' <- deRefStablePtr nut
    let num = fromInteger. toInteger . length $ nutPlots nut' :: CInt
    pure num

-- | Name of Nut Plot at given index
nameOfPlot :: StablePtr NutMeg -> CInt -> IO CString
nameOfPlot nut idx = do
    nut' <- deRefStablePtr nut
    let idx' = fromInteger $ toInteger idx :: Int
        name = (!!idx') . M.keys $  nutPlots nut'
    newCString name

-- | Get Plot by given name
plotByName :: StablePtr NutMeg -> CString -> IO (StablePtr NutPlot)
plotByName nut name = do
    nut'  <- deRefStablePtr nut
    name' <- peekCString name
    let plt' = fromJust . M.lookup name' $ nutPlots nut'
    newStablePtr plt'

-- | Get Plot at given Index
plotByIndex :: StablePtr NutMeg -> CInt -> IO (StablePtr NutPlot)
plotByIndex nut idx = nameOfPlot nut idx >>= plotByName nut 

-- | Number of Variables in the nutplot
numOfVars :: StablePtr NutPlot -> IO CInt
numOfVars plt = do
    plt' <- deRefStablePtr plt
    let num = fromInteger . toInteger $ nutNumVars plt' :: CInt
    putStrLn $ "Number of Vars: " ++ show num
    pure num

-- numOfVars plt = fromInteger . toInteger . nutNumVars <$> deRefStablePtr plt

-- | Name of the variable at given index
nameOfVar :: StablePtr NutPlot -> CInt -> IO CString
nameOfVar plt idx = do
    plt' <- deRefStablePtr plt
    let idx' = fromInteger $ toInteger idx :: Int
        name = (!!idx') $ nutVariables plt'
    newCString name

-- | Number of points in Waves
numOfPoints :: StablePtr NutPlot -> IO CInt
numOfPoints plt = fromInteger . toInteger . nutNumPoints <$> deRefStablePtr plt

-- | Nut Plot Wave by Variable Name
waveByName :: StablePtr NutPlot -> CString -> IO (StablePtr NutWave)
waveByName plt name = do
    name' <- peekCString name
    plt' <- fromJust . M.lookup name' . nutData <$> deRefStablePtr plt
    newStablePtr plt'

-- | Nut Plot Wave by Variable Index
waveByIndex :: StablePtr NutPlot -> CInt -> IO (StablePtr NutWave)
waveByIndex plt idx = nameOfVar plt idx >>= waveByName plt

-- | Is Complex? 1 = True, 0 = False
isComplex :: StablePtr NutPlot -> IO CInt
isComplex plt = do
    plt' <- deRefStablePtr plt
    if nutPlotType plt' == NutComplexPlot
       then pure 1
       else pure 0

-- | Real Part of a Vector
realData :: StablePtr NutWave -> Ptr CDouble -> IO ()
realData wav arr = do
    wav' <- deRefStablePtr wav
    let dat = either (map (CDouble . realPart) . V.toList) 
                     (map CDouble . V.toList) 
                     $ nutWave wav'
    pokeArray arr dat

-- | Imaginary Part of vector or empty list if only real
imagData :: StablePtr NutWave -> Ptr CDouble -> IO ()
imagData wav arr = do
    wav' <- deRefStablePtr wav
    let dat = either (map (CDouble . imagPart) . V.toList) 
                     (const []) 
                     $ nutWave wav'
    pokeArray arr dat

-- Spectre Exports

foreign export ccall version :: IO CString
foreign export ccall simulate :: Ptr CString -> CInt -> CString 
                              -> IO (StablePtr NutMeg)
foreign export ccall startSession :: Ptr CString -> CInt -> CString 
                                  -> IO (StablePtr SI.Session)
foreign export ccall stopSession :: StablePtr SI.Session -> IO ()

-- Nutmeg Exports

foreign export ccall numOfPlots :: StablePtr NutMeg -> IO CInt
foreign export ccall nameOfPlot :: StablePtr NutMeg -> CInt -> IO CString
foreign export ccall plotByName :: StablePtr NutMeg -> CString -> IO (StablePtr NutPlot)
foreign export ccall plotByIndex :: StablePtr NutMeg -> CInt -> IO (StablePtr NutPlot)
foreign export ccall numOfVars :: StablePtr NutPlot -> IO CInt
foreign export ccall nameOfVar :: StablePtr NutPlot -> CInt -> IO CString
foreign export ccall numOfPoints :: StablePtr NutPlot -> IO CInt
foreign export ccall waveByName :: StablePtr NutPlot -> CString -> IO (StablePtr NutWave)
foreign export ccall waveByIndex :: StablePtr NutPlot -> CInt -> IO (StablePtr NutWave)
foreign export ccall isComplex :: StablePtr NutPlot -> IO CInt
foreign export ccall realData :: StablePtr NutWave -> Ptr CDouble -> IO ()
foreign export ccall imagData :: StablePtr NutWave -> Ptr CDouble -> IO ()
