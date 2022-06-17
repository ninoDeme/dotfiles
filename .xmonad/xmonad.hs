-- Imports
--

import Data.Monoid
import Data.Maybe (fromJust)
import System.Exit
import XMonad
import XMonad.Util.Cursor
import XMonad.Actions.CopyWindow
import XMonad.Actions.GroupNavigation
import XMonad.Config.Desktop
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Util.EZConfig
import XMonad.Util.NamedActions
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- Terminal padrão
--
myTerminal      :: [Char]
myTerminal      = "kitty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Use xmobar?
useXmobar :: Bool
useXmobar = False
-- Width of the window border in pixels.
--
myBorderWidth   :: Dimension
myBorderWidth   = 2

myFont = "xft:NotoMono Nerd Font:weight=bold:pixelsize=11:antialias=true:hinting=true"

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       :: KeyMask
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces :: [[Char]]
myWorkspaces = ["1","2","3","4","5","6","7","8","9"]
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices


-- Border colors for unfocused and focused windows, respectively.
--

myNormalBorderColor  :: [Char]
myFocusedBorderColor :: [Char]
myNormalBorderColor  = "#535d6c"
myFocusedBorderColor = "#5294e2"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys :: XConfig l0 -> [((KeyMask, KeySym), NamedAction)]
myKeys c = customKeys c ++ workspaceKeys c ++ volumeKeys c

customKeys :: XConfig l -> [((KeyMask, KeySym), NamedAction)]
customKeys c = (subtitle "Custom Keys":) $ mkNamedKeymap c

    -- launch a terminal
    [ ("M-<Return>", addName "Launch Terminal" $ spawn myTerminal)
    , ("M-x", addName "Launch Terminal" $ spawn myTerminal)

    -- launch a terminal
    , ("M-C-<Return>", addName "Launch quake Terminal" $ namedScratchpadAction scratchpads "quakeTerm")
    , ("M-C-x", addName "Launch quake Terminal" $ namedScratchpadAction scratchpads "quakeTerm")

    -- launch rofi "run menu"
    , ("M-<Space>", addName "Launch Run Menu (rofi)" $ spawn "rofi -modi drun,run,window,combi -combi-modi window,drun -show combi -window-thumbnail true -show-icons true")
    , ("M-C-<Space>", addName "Launch dmenu" $ spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")

    -- launch file managers
    , ("M-e", addName "Launch vifm file manager" $ runInTerm "" "vifm")
    , ("M-S-e", addName "Launch visual file manager" $ spawn "xdg-open $HOME")

    -- launch firefox
    , ("M-b", addName "Launch Firefox" $ spawn "firefox")

    -- launch discord
    , ("M-d", addName "Launch Discord" $ spawn "flatpak run com.discordapp.Discord")

    -- kill polybar
    , ("M-f", addName "Hide Polybar" $ spawn "killall polybar")

    -- launch polybar
    , ("M-S-f", addName "Show Polybar" $ spawn "polybar --config=~/.xmonad/polybar/polybar.ini xmonad")

    -- launch steam
    , ("M-s", addName "Launch Steam" $ spawn "steam")

    -- launch lutris
    , ("M-S-s", addName "Launch lutris" $ spawn "lutris")

    -- launch vscode
    , ("M-z", addName "Launch Vscode" $ spawn "code")

    -- launch emacs
    , ("M-S-z", addName "Launch Emacs" $ spawn "emacsclient -c -a=\"\"")

    -- print screen
    , ("<Print>", addName "Print Screen" $ spawn "flameshot gui")

    -- launch monitor
    , ("M-m", addName "Launch Task Manager" $ spawn "mate-system-monitor")
    , ("M-S-m", addName "Launch Terminal-based Task Manager" $ runInTerm "" "htop")

    -- close focused window
    , ("M-S-c", addName "Close Focused Window" kill)

     -- Rotate through the available layout algorithms
    , ("M-<Tab>", addName "Cycle Through Available Layouts" $ sendMessage NextLayout)

    -- Resize viewed windows to the correct size
    , ("M-n", addName "Resize Windows To The Correct Size" refresh)

    -- Alt-Tab
    , ("M1-<Tab>", addName "Alt-Tab" $ nextMatch Forward (return True))

    -- Move focus to the next window
    , ("M-j", addName "Move focus to the next window" $ windows W.focusDown)

    -- Move focus to the previous window
    , ("M-k", addName "Move focus to the previous window" $ windows W.focusUp  )

    -- Move focus to the master window
    , ("M-C-m", addName "Move focus to the master window" $ windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ("M-S-<Return>", addName "Make focused window the master window" $ windows W.swapMaster)

    -- Swap the focused window with the next window
    , ("M-S-j", addName "Swap the focused window with the next window" $ windows W.swapDown)

    -- Swap the focused window with the previous window
    , ("M-S-k", addName "Swap the focused window with the previous window" $ windows W.swapUp    )

    -- Shrink the master area
    , ("M-h", sendMessage' Shrink)

    -- Expand the master area
    , ("M-l", sendMessage' Expand)

    -- Push window back into tiling
    , ("M-t", addName "Push window back into tiling" $ withFocused ( windows . W.sink))

    -- Increment the number of windows in the master area
    , ("M-,", sendMessage' (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ("M-.", sendMessage' (IncMasterN (-1)))

    -- Make focused window always visible
    , ("M-v", addName "Make focussed window always visible" $ windows copyToAll)

    -- Toggle window state back
    , ("M-S-v", addName "Make window only vissible in one workspace" killAllOtherCopies)

    -- Toggle the status bar gap
    , ("M-S-b", addName "Toggle docks" $ sendMessage ToggleStruts)

    -- Quit xmonad
    , ("M-S-q", addName "LogOut" $ io exitSuccess)

    -- Restart xmonad
    , ("M-S-r", addName "Restart Xmonad" $ spawn "xmonad --recompile; killall xmobar ; xmonad --restart")

    --
    -- Super-1..9, Switch to workspace N
    -- Super-shift-1..9, Move client to workspace N
    --
    ]


workspaceKeys :: XConfig l -> [((KeyMask, KeySym), NamedAction)]
workspaceKeys c = (subtitle "Workspaces":) $ mkNamedKeymap c $

    [("M-" ++ m ++ k, addName (desc ++ k) $ windows (f i))
        | (i, k) <- zip myWorkspaces ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
        , (f, m, desc) <- [(W.view, "", "Switch to workspace "), (W.shift, "S-", "Move focused window to workspace "), (copy, "C-S-", "Copy current window to workspace ")]]


volumeKeys :: XConfig l -> [((KeyMask, KeySym), NamedAction)]
volumeKeys c = (subtitle "Volume Keys":) $ mkNamedKeymap c
    [ ("<XF86AudioLowerVolume>", addName "Lower Volume" $ spawn "amixer -D pulse set Master 2%-")
    , ("<XF86AudioRaiseVolume>", addName "Raise Volume" $ spawn "amixer -D pulse set Master 2%+")
    , ("<XF86AudioMute>", addName "Mute" $ spawn "amixer set Master toggle")
    ]

    --end


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings :: XConfig l -> M.Map (KeyMask, Button) (Window -> X ())
myMouseBindings XConfig {XMonad.modMask = modm} = M.fromList

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), \w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster)

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), \w -> focus w >> windows W.shiftMaster)

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), \w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster)

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Scratchpads:
--
--
scratchpads = [
           NS "quakeTerm" (myTerminal ++ " -T=quakeTerminal") (title =? "quakeTerminal") (customFloating $ W.RationalRect 0 0 1 (1/2))
              ]
------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = spacingRaw True (Border 0 5 5 5) True (Border 5 5 5 5) True  (avoidStruts (smartBorders ( tiled ||| (Mirror tiled))))  ||| smartBorders Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook :: Query (Endo WindowSet)
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "Wine"           --> doFloat
    , className =? "leagueclientux.exe" --> doFloat
    , title =? "Whisker Menu"   --> doIgnore
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

colorBack = "#282c34"
colorFore = "#bbc2cf"

color01 = "#1c1f24"
color02 = "#ff6c6b"
color03 = "#98be65"
color04 = "#da8548"
color05 = "#51afef"
color06 = "#c678dd"
color07 = "#5699af"
color08 = "#202328"
color09 = "#5b6268"
color10 = "#da8548"
color11 = "#4db5bd"
color12 = "#ecbe7b"
color13 = "#3071db"
color14 = "#a9a1e1"
color15 = "#46d9ff"
color16 = "#dfdfdf"

myLogHook h True = dynamicLogWithPP $ namedScratchpadFilterOutWorkspacePP $ xmobarPP 
              { ppOutput = hPutStrLn h 
                -- Current workspace
              , ppCurrent = xmobarColor color06 "" . wrap
                            ("<box type=Bottom width=2 mb=2 color=" ++ color06 ++ ">") "</box>"
                -- Visible but not current workspace
              , ppVisible = xmobarColor color06 "" . clickable
                -- Hidden workspace with windows
              , ppHidden = xmobarColor color05 "" . wrap
                           ("<box type=Bottom width=2 mt=2 color=" ++ color05 ++ ">") "</box>" . clickable
                -- Hidden workspaces (no windows)
              , ppHiddenNoWindows = xmobarColor color05 ""  . clickable
                -- Title of active window
              , ppTitle = xmobarColor color16 "" . shorten 120
                -- Separator character
              , ppSep =  "<fc=" ++ color09 ++ "> <fn=1>|</fn> </fc>"
                -- Urgent workspace
              , ppUrgent = xmobarColor color02 "" . wrap "!" "!"
                -- Adding # of windows on current workspace to the bar
              , ppExtras  = [windowCount]
                -- order of things in xmobar
              , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
              }

myLogHook h False = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook :: X()
myStartupHook = do
  setDefaultCursor xC_left_ptr
  spawnOnce "nitrogen --restore &"
  spawnOnce "/usr/lib/xfce4/notifyd/xfce4-notifyd &"
  -- spawnOnce "xinput --set-prop 'Logitech G502 HERO Gaming Mouse' 'libinput Accel Speed' -1"
  spawnOnce "picom --experimental-backends --config ~/.xmonad/picom/picom.conf &"
  if useXmobar then spawn "killall polybar"
  else spawn "killall polybar; polybar --config=~/.xmonad/polybar/polybar.ini xmonad &"
  spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg) &"
  spawnOnce "numlockx on &"
  spawnOnce "nm-applet"
  spawnOnce "flatpak run com.discordapp.Discord --start-minimized &"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.


spawnXmobar True = do 
  spawnPipe "xmobar $HOME/.xmonad/xmobar.config"
spawnXmobar False = do 
  spawnPipe ""
-- Run xmonad with the settings you specify. No need to modify this.
--
main :: IO ()
main = do
  -- start xmonad
  xmproc <- spawnXmobar useXmobar
--  xmproc <- spawnPipe "xmobar $HOME/.xmonad/xmobar.config"
  xmonad $  ewmh . docks $ addDescrKeys' ((mod4Mask, xK_F1), xMessage) myKeys (defaults xmproc)
  xmonad desktopConfig

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults xmproc = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = manageDocks <+> myManageHook <+> namedScratchpadManageHook scratchpads, -- make sure to include myManageHook definition from above
        handleEventHook    = handleEventHook def,
        startupHook        = myStartupHook,
      -- 
        logHook            = myLogHook xmproc useXmobar
    }
