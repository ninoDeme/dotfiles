-- Imports
--

import Data.Monoid
import System.Exit
import XMonad
import XMonad.Util.Cursor
import XMonad.Actions.CopyWindow
import XMonad.Actions.GroupNavigation
import XMonad.Config.Desktop
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
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

-- Width of the window border in pixels.
--
myBorderWidth   :: Dimension
myBorderWidth   = 2

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

-- Border colors for unfocused and focused windows, respectively.
--

myNormalBorderColor  :: [Char]
myFocusedBorderColor :: [Char]
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#0000dd"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys :: XConfig l0 -> [((KeyMask, KeySym), NamedAction)]
myKeys c = customKeys c ++ workspaceKeys c ++ volumeKeys c

customKeys :: XConfig l -> [((KeyMask, KeySym), NamedAction)]
customKeys c = (subtitle "Custom Keys":) $ mkNamedKeymap c

    -- launch a terminal
    [ ("M-<Return>", addName "Launch Terminal" $ spawn myTerminal)

    -- launch a terminal
    , ("M-C-<Return>", addName "Launch quake Terminal" $ namedScratchpadAction scratchpads "quakeTerm")

    -- launch rofi "run menu"
    , ("M-x", addName "Launch Run Menu (rofi)" $ spawn "rofi -modi drun,run,window,combi -combi-modi window,drun -show combi -window-thumbnail true -show-icons true")
    , ("M-S-x", addName "Launch dmenu" $ spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")

    -- launch file managers
    , ("M-e", addName "Launch vifm file manager" $ runInTerm "" "vifm")
    , ("M-S-e", addName "Launch visual file manager" $ spawn "xdg-open $HOME")

    -- launch firefox
    , ("M-b", addName "Launch Firefox" $ spawn "firefox")

    -- launch discord
    , ("M-d", addName "Launch Discord" $ spawn "discord;flatpak run com.discordapp.Discord")

    -- kill polybar
    , ("M-f", addName "Hide Polybar" $ spawn "killall polybar")

    -- launch polybar
    , ("M-S-f", addName "Show Polybar" $ spawn "polybar --config=~/.xmonad/polybar/polybar.ini example")

    -- launch steam
    , ("M-s", addName "Launch Steam" $ spawn "steam")

    -- launch lutris
    , ("M-S-s", addName "Launch lutris" $ spawn "lutris")

    -- launch vscode
    , ("M-z", addName "Launch Vscode" $ spawn "code")

    -- launch emacs
    , ("M-S-z", addName "Launch Emacs" $ spawn "emacsclient -c -a=\"\"")

    -- launch monitor
    , ("M-m", addName "Launch Task Manager" $ spawn "mate-system-monitor")
    , ("M-S-m", addName "Launch Terminal-based Task Manager" $ runInTerm "" "htop")

    -- close focused window
    , ("M-S-c", addName "Close Focused Window" kill)

     -- Rotate through the available layout algorithms
    , ("M-<Space>", addName "Cycle Through Available Layouts" $ sendMessage NextLayout)

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
    , ("M-q", addName "Restart Xmonad" $ spawn "xmonad --recompile; xmonad --restart")

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
myLayout = spacingRaw True (Border 0 5 5 5) True (Border 5 5 5 5) True $ avoidStruts (smartBorders tiled ||| Mirror tiled ||| Full)
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
-- myLogHook =
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
  spawnOnce "nitrogen --restore"
  -- spawnOnce "xinput --set-prop 'Logitech G502 HERO Gaming Mouse' 'libinput Accel Speed' -1"
  spawnOnce "picom --experimental-backends"
  spawn "killall polybar; polybar --config=~/.xmonad/polybar/polybar.ini example"
  ewmhDesktopsStartup
  spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)"
  spawnOnce "numlockx on"
  spawnOnce "discord --start-minimized"
  spawnOnce "flatpak run com.discordapp.Discord --start-minimized"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main :: IO ()
main = do
  -- start xmonad
  xmonad $ docks $ addDescrKeys' ((mod4Mask, xK_F1), xMessage) myKeys defaults
  xmonad desktopConfig

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
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

      -- key bindings
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = manageDocks <+> myManageHook <+> namedScratchpadManageHook scratchpads, -- make sure to include myManageHook definition from above
        handleEventHook    = handleEventHook def <+> ewmhDesktopsEventHook,
        logHook            = ewmhDesktopsLogHook,
        startupHook        = myStartupHook
    }
