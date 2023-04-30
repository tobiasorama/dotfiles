module MyModules.Themes (VisualTheme (..) ) where
data VisualTheme = VisualTheme {
      black   :: (String, String)
    , red     :: (String, String)
    , green   :: (String, String)  
    , yellow  :: (String, String)
    , blue    :: (String, String)  
    , magenta :: (String, String)
    , cyan    :: (String, String) 
    , white   :: (String, String)
    } deriving (Show)
