import Data.List.Split (split, oneOf, dropDelims, condense)
import Data.List (elemIndex)
import System.IO (openFile, IOMode(ReadMode), hGetContents)
import System.Environment
import MyModules.Themes (VisualTheme(..))

parseKittyThemeFile :: String -> IO VisualTheme
parseKittyThemeFile contents = do
    let stringLines = lines contents
        getColourIndex colour = elemIndex ("#: " ++ colour) $ stringLines
        hexCode line = (split (condense . dropDelims $ oneOf " ") line) !! 1
        colourPair index = case index of
                    Just number -> (hexCode $ stringLines !! (number + 1), hexCode $ stringLines !! (number + 2))
                    Nothing     -> ("#000000", "#000000")
    let newTheme = VisualTheme {
          black   = colourPair $ getColourIndex "black"
        , red     = colourPair $ getColourIndex "red"
        , green   = colourPair $ getColourIndex "green"
        , yellow  = colourPair $ getColourIndex "yellow"
        , blue    = colourPair $ getColourIndex "blue"
        , magenta = colourPair $ getColourIndex "magenta"
        , cyan    = colourPair $ getColourIndex "cyan"
        , white   = colourPair $ getColourIndex "white"    
    }
    return newTheme

generateThemeModule :: String -> String -> IO ()
generateThemeModule fileName themeName = do
    handle <- openFile fileName ReadMode
    contents <- hGetContents handle
    theme <- parseKittyThemeFile contents
    writeFile (themeName ++ ".hs") ("module " ++ themeName ++ " ( newTheme ) " ++ " where\n\n" ++ "import MyModules.Themes (VisualTheme (..))\n\n" ++ "newTheme :: VisualTheme\nnewTheme = " ++ (show theme)) 
    return ()
