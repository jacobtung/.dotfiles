--                     jacob's xmonad config file                     --
------------------------------------------------------------------------

-- IMPORTS
------------------------------------------------------------------------
--import XMonad.Layout.Tabbed
--import XMonad.Layout.Renamed
--import XMonad.Layout.NoBorders
--import XMonad.Layout.Decoration
--import XMonad.Layout.SimpleDecoration
--import XMonad.Layout.MultiToggle
--import XMonad.Hooks.DynamicLog  -- xmobar
import XMonad
import Data.Monoid
import System.Exit
import System.IO
import XMonad.Actions.SpawnOn       -- autostart system workspace
import XMonad.Actions.DynamicProjects
import XMonad.Hooks.EwmhDesktops    -- ewmh 
import XMonad.Layout.ShowWName      -- show workspace name
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
import XMonad.Actions.GridSelect
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import qualified XMonad.Layout.MultiToggle as MT

-- BASIC SETTINGS
------------------------------------------------------------------------
myTerminal :: String
myTerminal      = "xterm"

myBrowser :: String
myBrowser       = "firefox-esr"

myModMask :: KeyMask
myModMask       = mod4Mask

myBorderWidth :: Dimension
myBorderWidth   = 0

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True
myClickJustFocuses :: Bool
myClickJustFocuses = False

myWorkspaces    = ["CLI","WWW","DOC","WS4","WS5","WS6","WS7","BGM","SYS"]
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True -- add spacing around window, first "False" turn off smartspacing(only one window no spacing)

myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
   -- { swn_font       = "Ubuntu:bold:size=60"
    { swn_fade       = 1
    , swn_bgcolor    = "#1c1f24"
    , swn_color      = "#ffffff"
    }

myNavigation :: TwoD a (Maybe a)
myNavigation = makeXEventhandler $ shadowWithKeymap navKeyMap navDefaultHandler
  where navKeyMap = M.fromList [
          ((0,xK_Escape), cancel)
         ,((0,xK_Return), select)
         ,((0,xK_slash) , substringSearch myNavigation)
         ,((0,xK_Left)  , move (-1,0)  >> myNavigation)
         ,((0,xK_h)     , move (-1,0)  >> myNavigation)
         ,((0,xK_l)     , move (1,0)   >> myNavigation)
         ,((0,xK_j)     , move (0,1)   >> myNavigation)
         ,((0,xK_k)     , move (0,-1)  >> myNavigation)
         ,((0,xK_space) , setPos (0,0) >> myNavigation)
         ]
        navDefaultHandler = const myNavigation

mygs_def = 
  [ ("poweroff",        "poweroff")
  , ("suspend",         "inwin_suspend")
  , ("reboot",          "reboot")
  , ("mirror1080p",     "mirror1080p")
  , ("record-gui",      "byzanz-record-gui")
  , ("printscreen",     "printscreen")
  , ("record-region",   "byzanz-record-region")
  , ("record-window",   "byzanz-record-window")
  , ("changekeyboard",  "changekeyboard")
  , ("mountsmb",        "mountsmb")
  , ("rime_restart",    "rime_restart")
  ]

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
    where conf = def
                   { gs_cellheight   = 40
                   , gs_cellwidth    = 200
                   , gs_cellpadding  = 6
                   , gs_originFractX = 0.5
                   , gs_originFractY = 0.5
                   , gs_navigate     = myNavigation
                   , gs_colorizer    = defaultColorizer 
--                 , gs_font         = myFont
                   }

projects :: [Project]
projects = 
    [ Project   { projectName       = "SYS"
                , projectDirectory  = "~/"
                , projectStartHook  = Just $ do spawnOnOnce "SYS" "xterm -e tty-clock -B -cn"
                                                spawnOnOnce "SYS" "xterm -e pulsemixer"
                                                spawnOnOnce "SYS" "xterm -e htop"
                }

    , Project   { projectName       = "BGM"
                , projectDirectory  = "~/"
                , projectStartHook  = Just $ do --  spawnOnOnce "BGM" "spotify %u"
                                                spawnOnOnce "BGM" "xterm -e ncmpcpp"
                } 

    , Project   { projectName       = "DOC"
                , projectDirectory  = "~/"
                , projectStartHook  = Just $ do spawnOnOnce "DOC" "thunar"
                }

    , Project   { projectName       = "WWW"
                , projectDirectory  = "~/"
                , projectStartHook  = Just $ do spawnOnOnce "WWW" "firefox-esr"
                }
                
    , Project   { projectName       = "CLI"
                , projectDirectory  = "~/"
                , projectStartHook  = Just $ do spawnOnOnce "CLI" "xterm" -- "xterm -e 'neofetch; $SHELL'"
                }
    ]

--HOOKS SETTINGS
------------------------------------------------------------------------
myStartupHook :: X ()
myStartupHook = do
    -- spawnOnce "picom -f &"
    -- SYS workspace 9
    -- spawnOnOnce "SYS" "xterm -e tty-clock -B -c -n" >> spawnOnOnce "SYS" "xterm -e pulsemixer" >> spawnOnOnce "SYS" "xterm -e htop"
    -- BGM workspace 8
    -- spawnOnOnce "BGM" "spotify" >> spawnOnOnce "BGM" "xterm -e ncmpcpp"
    -- DOC workspace 3
    -- spawnOnOnce "DOC" "thunar"
    -- WWW workspace 2
    -- spawnOnOnce "WWW" "firefox-esr"
    -- CLI workspace 1
    -- spawnOnOnce "CLI" "xterm"
    -- others
    spawnOnce "feh -z --bg-fill --no-fehbg /home/jacob/Pictures/Backgrounds/linux-debian-wallpaper.jpg"
    -- >> checkKeymap defaults myKeys                         -- EZConfig func to help you check keymap conflicts

myKeys :: [(String, X ())]
myKeys =
    -- Xmonad
        [ ("M-C-r", spawn "xmonad --recompile;xmonad --restart")  -- Recompiles xmonad
        , ("M-C-q", io exitSuccess)            -- Quits xmonad
    -- Run Dmenu
        , ("M-p", spawn "dmenu_run") -- Dmenu
        , ("M-S-p", spawnSelected' mygs_def)
        , ("M-q", spawn "")
    -- Useful programs to have a keybinding for launch
        , ("M-S-<Return>", spawn (myTerminal))
        , ("M-S-w", spawn (myBrowser))
        , ("M-S-g", spawn "firefox-esr -new-window https://gmail.com" )
        , ("M-S-d", spawn "firefox-esr -new-window https://calendar.google.com" )
        , ("M-S-y", spawn "firefox-esr -new-window https://www.youtube.com/" )
    --    , ("M-S-b", spawn "~/.local/bin/Bitwarden*.AppImage --no-sandbox %U")
        , ("M-S-e", spawn "thunar")
        , ("M-S-s", spawn "spotify")
        , ("M-S-l", spawn "slock")
    --    , ("<Print>", spawn "printscreen")
    -- Kill windows
        , ("M-S-c", kill)     -- Kill the currently focused client
    -- Windows navigation
        , ("M-m", windows W.focusMaster)  -- Move focus to the master window
        , ("M-j", windows W.focusDown)    -- Move focus to the next window
        , ("M-k", windows W.focusUp)      -- Move focus to the prev window
        , ("M-S-m", windows W.swapMaster) -- Swap the focused window and the master window
        , ("M-S-j", windows W.swapDown)   -- Swap focused window with next window
        , ("M-S-k", windows W.swapUp)     -- Swap focused window with prev window
  --      , ("M-<Backspace>", promote)      -- Moves focused window to master, others maintain order
    -- Layouts
   --     , ("M-<Tab>", sendMessage NextLayout)           -- Switch to next layout
  --      , ("M-b", toggleCollapse)
        -- jacob's method to implement Toggle to Hide Xmobar
--       , ("M-b", spawn "dbus-send --session --dest=org.Xmobar.Control --type=method_call --print-reply '/org/Xmobar/Control'  org.Xmobar.Control.SendSignal \"string:Toggle -1\"" >> (broadcastMessage $ ToggleStruts) >> refresh) -- toggle to show dock
        , ("M-<Return>", sendMessage $ MT.Toggle NBFULL)  -- >> sendMessage ToggleStruts) -- Toggles noborder/full
    -- Increase/decrease windows in the master pane or the stack
        , ("M-S-=", sendMessage (IncMasterN 1))      -- Increase # of clients master pane
        , ("M-S--", sendMessage (IncMasterN (-1))) -- Decrease # of clients master pane
    -- Window resizing
        , ("M-h", sendMessage Shrink)                   -- Shrink horiz window width
        , ("M-l", sendMessage Expand)                   -- Expand horiz window width
    -- Multimedia Keys
        , ("M-C-=", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5% && notify-send -t 200 `pulsemixer --get-volume | awk '{print $1}'`")
        , ("M-C--", spawn "pactl set-sink-volume @DEFAULT_SINK@ -5% && notify-send -t 200 `pulsemixer --get-volume | awk '{print $1}'`")
        , ("M-C-m", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle && notify-send -t 200 'Toggle mute button!'")
        , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle && notify-send -t 200 'Toggle mute button!'")
        , ("<XF86AudioMicMute>", spawn "pactl set-source-mute @DEFAULT_SOURCE@ toggle")
        , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -5% && notify-send -t 200 `pulsemixer --get-volume | awk '{print $1}'`")
        , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5% && notify-send -t 200 `pulsemixer --get-volume | awk '{print $1}'`")
        ]

myLayout = id . MT.mkToggle ( MT.single NBFULL) $ addTopBar $ mySpacing 3 tiled      -- ||| Full
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
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

--myEventHook = handleEventHook def <+> fullscreenEventHook

--myLogHook :: Handle -> X ()
--myLogHook xmproc = dynamicLogWithPP $ xmobarPP { ppOutput = hPutStrLn xmproc 
--              , ppCurrent = xmobarColor "#98be65" "" . wrap "[" "]"  
--              , ppVisible = xmobarColor "#98be65" ""
--              , ppHidden = xmobarColor "#82AAFF" "" . wrap "*" ""
--              , ppHiddenNoWindows = xmobarColor "#c792ea" ""
--              , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"  
--              , ppSep =  " | "  
--       --       , ppTitle = xmobarColor "#b3afc2" "" . shorten 60 
--            --, ppOrder  = \(ws:l:t) -> [ws,l]++[t]   
--              }            

-- MAIN
------------------------------------------------------------------------
main :: IO ()
main = do
--    xmproc <- spawnPipe "xmobar /home/jacob/.config/xmobar/xmobarrc"
    xmonad $dynamicProjects projects $ ewmh $ docks defaults -- { logHook = myLogHook xmproc }

defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,

      -- hooks, layouts
        layoutHook         = showWName' myShowWNameTheme myLayout,
        manageHook         = manageSpawn <+> myManageHook,
   --     handleEventHook    = myEventHook,
     --   logHook            = return (),
        startupHook        = myStartupHook -- <+> setFullscreenSupported -- real fullscreen support
        }  `additionalKeysP` myKeys

-- HISTORY CODE
------------------------------------------------------------------------
{-
1.import for setFullscreenSupported in startupHook for real fullscreen support
    -- import Control.Monad
    -- import Data.Maybe
    -- import Data.List
2. func for set FullscreenSupported in startupHook
    -- setFullscreenSupported :: X ()
    -- setFullscreenSupported = addSupported ["_NET_WM_STATE", "_NET_WM_STATE_FULLSCREEN"]
    -- addSupported :: [String] -> X ()
    -- addSupported props = withDisplay $ \dpy -> do
    --     r <- asks theRoot
    --     a <- getAtom "_NET_SUPPORTED"
    --     newSupportedList <- mapM (fmap fromIntegral . getAtom) props
    --     io $ do
    --       supportedList <- fmap (join . maybeToList) $ getWindowProperty32 dpy a r
    --       changeProperty32 dpy r a aTOM propModeReplace (nub $ newSupportedList ++ supportedList)
    -- func end
3.add to starthook
    -- startupHook        = myStartupHook -- <+> setFullscreenSupported -- real fullscreen support
-}
