--     ███          ██         █████   ██    ██        █ ███        █████ █     ██                         █████ ██
--   █████       ████  █   ██████  █████ █████      █  ████     ██████  ██    ████ █    █████          ██████  ███
--  █   ███      ██████   ██   █  █  █████ █████   █  █  ███   ██   █  █ ██    ████    █  ███        ██    █  █ ███
--       ███    █   ██   █    █  █   █ ██  █ ██   █  ██   ███ █    █  █  ██    █ █        ███       █     █  █   ███
--        ███  █             █  █    █     █     █  ███    ███    █  █    ██   █         █  ██       █   █  █     ███
--         ████             ██ ██    █     █    ██   ██     ██   ██ ██    ██   █         █  ██          ██ ██      ██
--          ███             ██ ██    █     █    ██   ██     ██   ██ ██     ██  █        █    ██         ██ ██      ██
--          ████            ██ ██    █     █    ██   ██     ██   ██ ██     ██  █        █    ██         ██ ██      ██
--         █  ███           ██ ██    █     █    ██   ██     ██   ██ ██      ██ █       █      ██        ██ ██      ██
--        █    ███          ██ ██    █     ██   ██   ██     ██   ██ ██      ██ █       █████████        ██ ██      ██
--       █      ███         █  ██    █     ██    ██  ██     ██   █  ██       ███      █        ██       █  ██      ██
--      █        ███           █     █      ██    ██ █      █       █        ███      █        ██          █       █
--     █          ███   █  ████      █      ██     ███     █    ████          ██     █████      ██    █████       █
--    █            █████  █  █████           ██     ███████    █  █████             █   ████    ██ █ █   █████████
--   █              ███  █     ██                     ███     █     ██             █     ██      ██ █       ████
--                       █                                    █                    █                █
--                        █                                    █                    █                █
--                         ██                                   ██                   ██               █
--                                                                                                     ██
--
-- Base
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Use head" #-}

import System.Directory
import System.Exit (exitSuccess)
import System.IO (hClose, hPutStr, hPutStrLn)
import XMonad
import qualified XMonad.StackSet as W

-- Actions
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS (Direction1D (..), WSType (..), moveTo, nextScreen, prevScreen, shiftTo, toggleWS)
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotAllDown, rotSlavesDown)
import qualified XMonad.Actions.Search as S
import XMonad.Actions.TreeSelect
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (killAll, sinkAll)

-- Data
import Data.Char (isSpace, toUpper)
import qualified Data.Map as M
import Data.Maybe (fromJust, isJust)
import Data.Monoid
import Data.Tree

-- Hooks
import XMonad.Hooks.DynamicLog (PP (..), dynamicLogWithPP, shorten, wrap, xmobarColor, xmobarPP)
import XMonad.Hooks.EwmhDesktops -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.ManageDocks (ToggleStruts (..), avoidStruts, docks, manageDocks)
import XMonad.Hooks.ManageHelpers (doCenterFloat, doFullFloat, isFullscreen)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.WindowSwallowing
import XMonad.Hooks.WorkspaceHistory

-- Layouts
import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid (Grid))
import XMonad.Layout.ResizableTile
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

-- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (decreaseLimit, increaseLimit, limitWindows)
import XMonad.Layout.MultiToggle (EOT (EOT), mkToggle, single, (??))
import qualified XMonad.Layout.MultiToggle as MT (Toggle (..))
import XMonad.Layout.MultiToggle.Instances (StdTransformers (MIRROR, NBFULL, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import qualified XMonad.Layout.ToggleLayouts as T (ToggleLayout (Toggle), toggleLayouts)
import XMonad.Layout.WindowArranger (WindowArrangerMsg (..), windowArrange)
import XMonad.Layout.WindowNavigation

-- Utilities

import XMonad.Util.Cursor
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig (additionalKeysP, mkNamedKeymap, removeKeysP)
import XMonad.Util.Hacks (javaHack, trayAbovePanelEventHook, trayPaddingEventHook, trayPaddingXmobarEventHook, trayerAboveXmobarEventHook, trayerPaddingXmobarEventHook, windowedFullscreenFixEventHook)
import XMonad.Util.NamedActions
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce

myFont :: String
myFont = "xft:Cascadia Code Mono:regular:size=10:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask -- Sets modkey to super/windows key

myTerminal :: String
myTerminal = "alacritty" -- Sets default terminal

myBrowser :: String
myBrowser = "firefox"
myFileExplorer :: String
myFileExplorer = "nautilus"

myEditor :: String
myEditor = myTerminal ++ " -e vim " -- Sets vim as editor

myBorderWidth :: Dimension
myBorderWidth = 2 -- Sets border width for windows

mySpacingValue :: Integer
mySpacingValue = 0

myNormColor :: String -- Border color of normal windows
myNormColor = "#000000"

myFocusColor :: String -- Border color of focused windows
myFocusColor = "#557E90"

mySoundPlayer :: String
mySoundPlayer = "ffplay -nodisp -autoexit " -- The program that will play system sounds

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myStartupHook :: X ()
myStartupHook = do
  spawn "picom --config ~/.config/picom/picom.conf &"
  spawnOnce "~/.fehbg &" -- set last saved feh wallpaper
  setWMName "xmonad"
  setDefaultCursor xC_left_ptr

myScratchPads :: [NamedScratchpad]
myScratchPads = [NS "calculator" spawnCalc findCalc manageCalc]
 where
  spawnCalc = "qalculate-gtk"
  findCalc = className =? "Qalculate-gtk"
  manageCalc = customFloating $ W.RationalRect l t w h
   where
    h = 0.5
    w = 0.4
    t = 0.75 - h
    l = 0.70 - w

-- Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

myBorder :: Integer -> Border
myBorder i = Border i i i i

-- Defining a bunch of layouts, many that I don't use.
-- limitWindows n sets maximum number of windows displayed for layout.
-- mySpacing n sets the gap size around the windows.
tall =
  renamed [Replace "tall"] $
    limitWindows 5 $
      smartBorders $
        windowNavigation $
          addTabs shrinkText myTabTheme $
            subLayout [] (smartBorders Simplest) $
              mySpacing mySpacingValue $
                ResizableTall 1 (3 / 100) (1 / 2) []
monocle =
  renamed [Replace "monocle"] $
    smartBorders $
      windowNavigation $
        addTabs shrinkText myTabTheme $
          subLayout
            []
            (smartBorders Simplest)
            Full
grid =
  renamed [Replace "grid"] $
    limitWindows 9 $
      smartBorders $
        windowNavigation $
          addTabs shrinkText myTabTheme $
            subLayout [] (smartBorders Simplest) $
              mySpacing mySpacingValue $
                mkToggle (single MIRROR) $
                  Grid (16 / 10)
tabs =
  renamed [Replace "tabs"]
  -- I cannot add spacing to this layout because it will
  -- add spacing between window and tabs which looks bad.
  $
    tabbed shrinkText myTabTheme

-- setting colors for tabs layout and tabs sublayout.
myTabTheme =
  def
    { fontName = myFont
    , activeColor = "#1e1f2b"
    , inactiveColor = "#444444"
    , activeBorderColor = "#910053"
    , inactiveBorderColor = "#000000"
    , activeTextColor = "#ffffff"
    , inactiveTextColor = "#666666"
    }

-- The layout hook
myLayoutHook =
  avoidStruts $
    mouseResize $
      windowArrange $
        mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
 where
  myDefaultLayout =
    withBorder myBorderWidth tall
      ||| noBorders monocle
      ||| noBorders tabs
      ||| grid

myWorkspaces =
  [ " <fn=2>\xf198</fn>"
  , " <fn=2>\xe795</fn>"
  , " <fn=2>\xe712</fn>"
  , " <fn=2>\xf059f</fn>"
  , " <fn=2>\xf0219</fn>"
  , " <fn=2>\xf08b9</fn>"
  , " <fn=2>\xf057c</fn>"
  , " <fn=2>\xeb6d</fn>"
  , " <fn=2>_</fn>"
  ]
myWorkspaceIndices = M.fromList $ zip myWorkspaces [1 ..]

clickable ws = "<action=xdotool key super+" ++ show i ++ ">" ++ ws ++ "</action>"
 where
  i = fromJust $ M.lookup ws myWorkspaceIndices

myManageHook =
  composeAll
    -- 'doFloat' forces a window to float.  Useful for dialog boxes and such.
    -- using 'doShift ( myWorkspaces !! 7)' sends program to workspace 8!
    -- I'm doing it this way because otherwise I would have to write out the full
    -- name of my workspaces and the names would be very long if using clickable workspaces.
    [ className =? "confirm" --> doCenterFloat
    , className =? "file_progress" --> doCenterFloat
    , className =? "dialog" --> doCenterFloat
    , className =? "download" --> doFloat
    , className =? "error" --> doFloat
    , className =? "Gimp" --> doFloat
    , className =? "Yad" --> doFloat
    , className =? "notification" --> doFloat
    , className =? "pinentry-gtk-2" --> doFloat
    , className =? "splash" --> doFloat
    , className =? "toolbar" --> doFloat
    , title =? "Mozilla Firefox" --> doShift (myWorkspaces !! 3)
    , className =? "qutebrowser" --> doShift (myWorkspaces !! 3)
    , className =? "mpv" --> doShift (myWorkspaces !! 7)
    , className =? "Gimp" --> doShift (myWorkspaces !! 8)
    , className =? "Lutris" --> doShift (myWorkspaces !! 4)
    , className =? "Runescape" --> doShift (myWorkspaces !! 4)
    , className =? "Steam" --> doShift (myWorkspaces !! 4)
    , className =? "discord" --> doShift (myWorkspaces !! 5)
    , className =? "Qemu-system-x86_64" --> doCenterFloat
    , stringProperty "WM_WINDOW_ROLE" =? "GtkFileChooserDialog" --> doCenterFloat
    , (className =? "firefox" <&&> resource =? "Dialog") --> doCenterFloat -- Float Firefox Dialog
    , isFullscreen --> doFullFloat
    ]
    <+> namedScratchpadManageHook myScratchPads

subtitle' :: String -> ((KeyMask, KeySym), NamedAction)
subtitle' x =
  ( (0, 0)
  , NamedAction $
      map toUpper $
        sep ++ "\n-- " ++ x ++ " --\n" ++ sep
  )
 where
  sep = replicate (6 + length x) '-'

showKeybindings :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
showKeybindings x = addName "Show Keybindings" $ io $ do
  h <- spawnPipe "yad --text-info --fontname=\"Cascadia Code Mono 14\" --fore=white --back=black --center --geometry=1200x800 --title \"XMonad keybindings\" --no-buttons"
  -- hPutStr h (unlines $ showKm x) -- showKM adds ">>" before subtitles
  hPutStr h (unlines $ showKmSimple x) -- showKmSimple doesn't add ">>" to subtitles
  hClose h
  return ()

powerOptionsDef :: XMonad.Actions.TreeSelect.TSConfig (X a)
powerOptionsDef =
  TSConfig
    { ts_hidechildren = True
    , ts_background = 0x00000000
    , ts_font = "xft:CascadiaCode-16"
    , ts_node = (0xff000000, 0x999999db)
    , ts_nodealt = (0xff000000, 0x999999d6)
    , ts_highlight = (0xff000000, 0x222222d6)
    , ts_extra = 0xff000000
    , ts_node_width = 200
    , ts_node_height = 30
    , ts_originX = 0
    , ts_originY = 0
    , ts_indent = 80
    , ts_navigate = XMonad.Actions.TreeSelect.defaultNavigation
    }
myKeys :: XConfig l0 -> [((KeyMask, KeySym), NamedAction)]
myKeys c =
  -- (subtitle "Custom Keys":) $ mkNamedKeymap c $
  let subKeys str ks = subtitle' str : mkNamedKeymap c ks
   in subKeys
        "Xmonad Essentials"
        [ ("M-q", addName "Restart XMonad" $ spawn "xmonad --restart")
        , ("M-S-c", addName "Kill focused window" kill1)
        , ("M-S-a", addName "Kill all windows on WS" killAll)
        ]
        ^++^ subKeys
          "Switch to workspace"
          [ ("M-1", addName "Switch to workspace 1" (windows $ W.greedyView $ myWorkspaces !! 0))
          , ("M-2", addName "Switch to workspace 2" (windows $ W.greedyView $ myWorkspaces !! 1))
          , ("M-3", addName "Switch to workspace 3" (windows $ W.greedyView $ myWorkspaces !! 2))
          , ("M-4", addName "Switch to workspace 4" (windows $ W.greedyView $ myWorkspaces !! 3))
          , ("M-5", addName "Switch to workspace 5" (windows $ W.greedyView $ myWorkspaces !! 4))
          , ("M-6", addName "Switch to workspace 6" (windows $ W.greedyView $ myWorkspaces !! 5))
          , ("M-7", addName "Switch to workspace 7" (windows $ W.greedyView $ myWorkspaces !! 6))
          , ("M-8", addName "Switch to workspace 8" (windows $ W.greedyView $ myWorkspaces !! 7))
          , ("M-9", addName "Switch to workspace 9" (windows $ W.greedyView $ myWorkspaces !! 8))
          , ("M-|", addName "Toggle previous workspace" XMonad.Actions.CycleWS.toggleWS)
          ]
        ^++^ subKeys
          "Send window to workspace"
          [ ("M-S-1", addName "Send to workspace 1" (windows $ W.shift $ myWorkspaces !! 0))
          , ("M-S-2", addName "Send to workspace 2" (windows $ W.shift $ myWorkspaces !! 1))
          , ("M-S-3", addName "Send to workspace 3" (windows $ W.shift $ myWorkspaces !! 2))
          , ("M-S-4", addName "Send to workspace 4" (windows $ W.shift $ myWorkspaces !! 3))
          , ("M-S-5", addName "Send to workspace 5" (windows $ W.shift $ myWorkspaces !! 4))
          , ("M-S-6", addName "Send to workspace 6" (windows $ W.shift $ myWorkspaces !! 5))
          , ("M-S-7", addName "Send to workspace 7" (windows $ W.shift $ myWorkspaces !! 6))
          , ("M-S-8", addName "Send to workspace 8" (windows $ W.shift $ myWorkspaces !! 7))
          , ("M-S-9", addName "Send to workspace 9" (windows $ W.shift $ myWorkspaces !! 8))
          ]
        ^++^ subKeys
          "Move window to WS and go there"
          [ ("M-S-<Page_Up>", addName "Move window to next WS" $ shiftTo Next nonNSP >> XMonad.Actions.CycleWS.moveTo Next nonNSP)
          , ("M-S-<Page_Down>", addName "Move window to prev WS" $ shiftTo Prev nonNSP >> XMonad.Actions.CycleWS.moveTo Prev nonNSP)
          ]
        ^++^ subKeys
          "Window navigation"
          [ ("M-<Tab>", addName "Move focus to next window" $ windows W.focusDown)
          , ("M-S-<Tab>", addName "Move focus to prev window" $ windows W.focusUp)
          , ("M-m", addName "Move focus to master window" $ windows W.focusMaster)
          , ("M-S-j", addName "Swap focused window with next window" $ windows W.swapDown)
          , ("M-S-k", addName "Swap focused window with prev window" $ windows W.swapUp)
          , ("M-S-m", addName "Swap focused window with master window" $ windows W.swapMaster)
          , ("M-<Backspace>", addName "Move focused window to master" promote)
          , ("M-S-,", addName "Rotate all windows except master" rotSlavesDown)
          , ("M-S-.", addName "Rotate all windows current stack" rotAllDown)
          ]
        ^++^ subKeys
          "Favorite programs"
          [ ("M-<Return>", addName "Launch terminal" $ spawn myTerminal)
          , ("M-b", addName "Launch web browser" $ spawn myBrowser)
          , ("M-p", addName "Launch DMenu" $ spawn "dmenu_run")
          , ("M-n", addName "Launch file explorer" $ spawn myFileExplorer)
          ]
        ^++^ subKeys
          "Power options"
          [
            ( "M-<End>"
            , addName "Power Options" $
                XMonad.Actions.TreeSelect.treeselectAction
                  powerOptionsDef
                  [ Node (TSNode "Lock" "" (spawn "slock")) []
                  , Node (TSNode "Logout" "" (io exitSuccess)) []
                  , Node (TSNode "Suspend" "" (spawn "slock && sleep 2 && zzz")) []
                  , Node (TSNode "Shutdown" "" (spawn "poweroff")) []
                  ]
            )
          ]
        ^++^ subKeys
          "Monitors"
          [ ("M-e", addName "Switch focus to next monitor" nextScreen)
          , ("M-w", addName "Switch focus to prev monitor" prevScreen)
          ]
        -- Switch layouts
        ^++^ subKeys
          "Switch layouts"
          [ ("M-<Space>", addName "Switch to next layout" $ sendMessage NextLayout)
          , ("M-f", addName "Toggle noborders/full" $ sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)
          ]
        -- Window resizing
        ^++^ subKeys
          "Window resizing"
          [ ("M-h", addName "Shrink window" $ sendMessage Shrink)
          , ("M-l", addName "Expand window" $ sendMessage Expand)
          , ("M-M1-j", addName "Shrink window vertically" $ sendMessage MirrorShrink)
          , ("M-M1-k", addName "Expand window vertically" $ sendMessage MirrorExpand)
          ]
        -- Floating windows
        ^++^ subKeys
          "Floating windows"
          [ ("M-S-f", addName "Toggle float layout" $ sendMessage (T.Toggle "floats"))
          , ("M-t", addName "Sink a floating window" $ withFocused $ windows . W.sink)
          , ("M-S-t", addName "Sink all floated windows" sinkAll)
          ]
        -- Increase/decrease spacing (gaps)
        ^++^ subKeys
          "Window spacing (gaps)"
          [ ("C-M1-j", addName "Decrease window spacing" $ decWindowSpacing 4)
          , ("C-M1-k", addName "Increase window spacing" $ incWindowSpacing 4)
          , ("C-M1-h", addName "Decrease screen spacing" $ decScreenSpacing 4)
          , ("C-M1-l", addName "Increase screen spacing" $ incScreenSpacing 4)
          , ("C-M1-r", addName "Reset window spacing" $ setWindowSpacing $ myBorder mySpacingValue)
          ]
        -- Increase/decrease windows in the master pane or the stack
        ^++^ subKeys
          "Increase/decrease windows in master pane or the stack"
          [ ("M-S-<Up>", addName "Increase clients in master pane" $ sendMessage (IncMasterN 1))
          , ("M-S-<Down>", addName "Decrease clients in master pane" $ sendMessage (IncMasterN (-1)))
          , ("M-=", addName "Increase max # of windows for layout" increaseLimit)
          , ("M--", addName "Decrease max # of windows for layout" decreaseLimit)
          ]
        -- Sublayouts
        -- This is used to push windows to tabbed sublayouts, or pull them out of it.
        ^++^ subKeys
          "Sublayouts"
          [ ("M-C-.", addName "Switch focus next tab" $ onGroup W.focusUp')
          , ("M-C-,", addName "Switch focus prev tab" $ onGroup W.focusDown')
          ]
        -- Scratchpads
        -- Toggle show/hide these programs. They run on a hidden workspace.
        -- When you toggle them to show, it brings them to current workspace.
        -- Toggle them to hide and it sends them back to hidden workspace (NSP).
        ^++^ subKeys
          "Scratchpads"
          [("M-s c", addName "Toggle scratchpad calculator" $ namedScratchpadAction myScratchPads "calculator")]
        -- Multimedia Keys
        ^++^ subKeys
          "Multimedia keys"
          [ ("<XF86AudioMute>", addName "Toggle audio mute" $ spawn "amixer sset Master toggle")
          , ("<XF86AudioLowerVolume>", addName "Lower vol" $ spawn "amixer sset Master 5%- unmute")
          , ("<XF86AudioRaiseVolume>", addName "Raise vol" $ spawn "amixer sset Master 5%+ unmute")
          , ("S-p", addName "Flameshot" $ spawn "flameshot gui")
          ]
	^++^ subKeys
	  "Brightness control"
	  [ ("M-j", addName "Decrease brightness" $ spawn "backlight decr")
          , ("M-k", addName "Increase brightness" $ spawn "backlight incr")
	  ]
 where
  -- The following lines are needed for named scratchpads.
  nonNSP = WSIs (return (\ws -> W.tag ws /= "NSP"))
  nonEmptyNonNSP = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))

-- colourscheme
currentWs :: String
currentWs = "#ffffff"

visibleWsNotCurrent :: String
visibleWsNotCurrent = "#585858"

hiddenWsNotVisible :: String
hiddenWsNotVisible = "#666666"

hiddenWsNoWindows :: String
hiddenWsNoWindows = "#333333"

wsTitle :: String
wsTitle = "#ffffff"

urgentWs :: String
urgentWs = "#cc0000"

main :: IO ()
main = do
  spawn "xss-lock slock"
  spawn "xinput set-prop 10 320 1"
  spawn "xinput set-prop 10 349 1"
  xmproc0 <- spawnPipe "xmobar -x 0 $HOME/.xmonad/xmobarrc"
  -- the xmonad, ya know...what the WM is named after!
  xmonad $
    addDescrKeys' ((mod4Mask, xK_F1), showKeybindings) myKeys $
      ewmh $
        docks $
          def
            { manageHook = myManageHook <+> manageDocks
            , handleEventHook = windowedFullscreenFixEventHook <> swallowEventHook (className =? "alacritty" <||> className =? "st-256color" <||> className =? "XTerm") (return True) <> trayerPaddingXmobarEventHook
            , modMask = myModMask
            , terminal = myTerminal
            , startupHook = myStartupHook
            , layoutHook = myLayoutHook
            , workspaces = myWorkspaces
            , borderWidth = myBorderWidth
            , normalBorderColor = myNormColor
            , focusedBorderColor = myFocusColor
            , logHook =
                dynamicLogWithPP $
                  filterOutWsPP [scratchpadWorkspaceTag] $
                    xmobarPP
                      { ppOutput = hPutStrLn xmproc0 -- xmobar on monitor 1
                      -- Current workspace
                      , ppCurrent = xmobarColor currentWs "" . clickable
                      , -- Visible but not current workspace
                        ppVisible = xmobarColor visibleWsNotCurrent ""
                      , -- Hidden workspace
                        ppHidden = xmobarColor hiddenWsNotVisible "" . clickable
                      , -- Hidden workspaces (no windows)
                        ppHiddenNoWindows = xmobarColor hiddenWsNoWindows "" . clickable
                      , -- Title of active window
                        ppTitle = xmobarColor wsTitle "" . shorten 60
                      , -- Separator character
                        ppSep = "  |  "
                      , -- Urgent workspace
                        ppUrgent = xmobarColor urgentWs "" . wrap "!" "!"
                      , -- order of things in xmobar
                        ppOrder = \(ws : t : ex) -> ws : ex
                      }
            }
            `removeKeysP` ["M-S-q"]

