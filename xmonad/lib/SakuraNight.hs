module SakuraNight ( newTheme )  where

import MyModules.Themes (VisualTheme (..))

newTheme :: VisualTheme
newTheme = VisualTheme {black = ("#181425","#262b44"), red = ("#e43b44","#ff0044"), green = ("#3e8948","#63c74d"), yellow = ("#feae34","#fee761"), blue = ("#124e89","#0099db"), magenta = ("#b55088","#F06292"), cyan = ("#008080","#66b2b2"), white = ("#c0cbdc","#ffffff")}
