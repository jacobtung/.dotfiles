-- JACOB'S XMONAD CONFIG FILE

------------------------------------------------------------------------
-- IMPORTS

-- not used now
--import XMonad.Layout.Tabbed
--import XMonad.Layout.Renamed
--import XMonad.Layout.NoBorders
--import XMonad.Layout.Decoration
--import XMonad.Layout.SimpleDecoration
--import XMonad.Layout.MultiToggle

-- import for setFullscreenSupported in startupHook for real fullscreen support
-- import Control.Monad
-- import Data.Maybe
-- import Data.List
---
import XMonad
import Data.Monoid
import System.Exit
import System.IO
import XMonad.Hooks.EwmhDesktops    -- ewmh 
import XMonad.Hooks.DynamicLog  -- xmobar
import XMonad.Layout.NoFrillsDecoration   --for window topbar
import XMonad.Layout.Simplest -- simplest layout fullscreen and overlap
import XMonad.Layout.MultiToggle.Instances -- toggle to sigal window (fake fullscreen)
import XMonad.Layout.Spacing --spacing around windows
import XMonad.Layout.ResizableTile --mirrorshrink and expand
import XMonad.Layout.LayoutModifier -- mySpacing 4
import XMonad.Hooks.ManageDocks --manage dock type programs
import XMonad.Util.Run --all kinds of run options
import XMonad.Util.EZConfig  --short keybinds; auto submap; keymap check conflicts
import XMonad.Util.SpawnOnce --startup hook to spawn a command only once; n time * n ws
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import qualified XMonad.Layout.MultiToggle as MT

------------------------------------------------------------------------
-- BASIC SETTINGS

myTerminal :: String
myTerminal      = "xterm"

myBrowser :: String
myBrowser       = "firefox"

myModMask :: KeyMask
myModMask       = mod4Mask

myBorderWidth :: Dimension
myBorderWidth   = 0
myNormalBorderColor :: String
myNormalBorderColor  = "#000000"
myFocusedBorderColor :: String
myFocusedBorderColor = "#ffffff"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True
myClickJustFocuses :: Bool
myClickJustFocuses = False

myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True -- add spacing around window, first "False" turn off smartspacing(only one window no spacing)

------------------------------------------------------------------------
--HOOKS SETTINGS

-- toggleCollapse :: X ()
-- toggleCollapse = do
--    toggleWindowSpacingEnabled
--    sendMessage ToggleStruts


myStartupHook :: X ()
myStartupHook = do
    -- spawnOnce "picom -f &"
    spawnOnce "~/.local/scripts/loadbg.sh &"
    >> checkKeymap defaults myKeys                         -- EZConfig func to help you check keymap conflicts

myKeys :: [(String, X ())]
myKeys =
    -- Xmonad
        [ ("M-C-r", spawn "xmonad --recompile;xmonad --restart")  -- Recompiles xmonad
        , ("M-C-q", io exitSuccess)            -- Quits xmonad
    -- Run Dmenu
        , ("M-p", spawn "dmenu_run") -- Dmenu
    -- Useful programs to have a keybinding for launch
        , ("M-S-<Return>", spawn (myTerminal))
        , ("M-S-w", spawn (myBrowser))
        , ("M-S-m", spawn "thunderbird" )
        , ("M-S-b", spawn "~/.local/bin/Bitwarden*.AppImage --no-sandbox %U")
        , ("M-S-e", spawn "thunar")
        , ("M-S-s", spawn "spotify")
    -- Kill windows
        , ("M-S-c", kill)     -- Kill the currently focused client
    -- Windows navigation
        , ("M-m", windows W.focusMaster)  -- Move focus to the master window
        , ("M-j", windows W.focusDown)    -- Move focus to the next window
        , ("M-k", windows W.focusUp)      -- Move focus to the prev window
        , ("M-C-m", windows W.swapMaster) -- Swap the focused window and the master window
        , ("M-C-j", windows W.swapDown)   -- Swap focused window with next window
        , ("M-C-k", windows W.swapUp)     -- Swap focused window with prev window
  --      , ("M-<Backspace>", promote)      -- Moves focused window to master, others maintain order
    -- Layouts
        , ("M-<Tab>", sendMessage NextLayout)           -- Switch to next layout
  --      , ("M-b", toggleCollapse)
        -- jacob's method to implement Toggle to Hide Xmobar
       , ("M-b", spawn "dbus-send --session --dest=org.Xmobar.Control --type=method_call --print-reply '/org/Xmobar/Control'  org.Xmobar.Control.SendSignal \"string:Toggle -1\"" >> (broadcastMessage $ ToggleStruts) >> refresh) -- toggle to show dock
        , ("M-<Return>", sendMessage $ MT.Toggle NBFULL)  -- >> sendMessage ToggleStruts) -- Toggles noborder/full
    -- Increase/decrease windows in the master pane or the stack
        , ("M-S-=", sendMessage (IncMasterN 1))      -- Increase # of clients master pane
        , ("M-S--", sendMessage (IncMasterN (-1))) -- Decrease # of clients master pane
    -- Window resizing
        , ("M-h", sendMessage Shrink)                   -- Shrink horiz window width
        , ("M-l", sendMessage Expand)                   -- Expand horiz window width
    -- Multimedia Keys
        , ("M-C-=", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
        , ("M-C--", spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
        , ("C-S-m", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle && notify-send 'Toggle mute button!'")
        , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
        , ("<XF86AudioMicMute>", spawn "pactl set-source-mute @DEFAULT_SOURCE@ toggle")
        , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
        , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
        ]

myLayout = id . MT.mkToggle ( MT.single NBFULL) $ avoidStruts $ addTopBar $ mySpacing 3 tiled      -- ||| Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100
     addTopBar = noFrillsDeco shrinkText ( def { 
      fontName              = "DejaVu Sans"
    , inactiveBorderColor   = "#002b36"
    , inactiveColor         = "#002b36"
    , inactiveTextColor     = "#002b36"
    , activeBorderColor     = "#268bd2"
    , activeColor           = "#268bd2"
    , activeTextColor       = "#268bd2"
    , urgentBorderColor     = "#dc322f"
    , urgentTextColor       = "#b58900"
    , decoHeight            = 4 }  ) 

myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

myEventHook = handleEventHook def <+> fullscreenEventHook

myLogHook :: Handle -> X ()
myLogHook xmproc = dynamicLogWithPP $ xmobarPP { ppOutput = hPutStrLn xmproc 
              , ppCurrent = xmobarColor "#98be65" "" . wrap "[" "]"  
              , ppVisible = xmobarColor "#98be65" ""
              , ppHidden = xmobarColor "#82AAFF" "" . wrap "*" ""
              , ppHiddenNoWindows = xmobarColor "#c792ea" ""
              , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"  
              , ppSep =  " | "  
       --       , ppTitle = xmobarColor "#b3afc2" "" . shorten 60 
            --, ppOrder  = \(ws:l:t) -> [ws,l]++[t]   
              }            
------------------------------------------------------------------------
-- MAIN

-- func for set FullscreenSupported in startupHook
-- setFullscreenSupported :: X ()
-- setFullscreenSupported = addSupported ["_NET_WM_STATE", "_NET_WM_STATE_FULLSCREEN"]
-- 
-- addSupported :: [String] -> X ()
-- addSupported props = withDisplay $ \dpy -> do
--     r <- asks theRoot
--     a <- getAtom "_NET_SUPPORTED"
--     newSupportedList <- mapM (fmap fromIntegral . getAtom) props
--     io $ do
--       supportedList <- fmap (join . maybeToList) $ getWindowProperty32 dpy a r
--       changeProperty32 dpy r a aTOM propModeReplace (nub $ newSupportedList ++ supportedList)
-- func end
main :: IO ()
main = do
    xmproc <- spawnPipe "xmobar /home/jacob/.config/xmobar/xmobarrc"
    xmonad  $ ewmh $ docks defaults { logHook = myLogHook xmproc }

defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = return (),
        startupHook        = myStartupHook -- <+> setFullscreenSupported -- real fullscreen support
        }  `additionalKeysP` myKeys
