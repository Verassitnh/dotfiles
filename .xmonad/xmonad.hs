--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import qualified Data.Map as M
import Data.Monoid
import System.Exit
import XMonad
import XMonad.Hooks.DynamicLog (PP (..), dynamicLogWithPP, shorten, wrap, xmobarColor, xmobarPP)
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.WorkspaceHistory
import XMonad.Layout.Spacing
import XMonad.Layout.WindowNavigation
import qualified XMonad.StackSet as W
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal = "kitty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = True

-- Width of the window border in pixels.
--
myBorderWidth = 0

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces = ["WWW", "DEV", "SYS", "CHAT", "EDU", "CHESS", "DOC", "MUS", "DASH"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor = "#1E232A"

myFocusedBorderColor = "#D94E5A"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) =
  M.fromList $
    --------------------------------------------------------------------- LAUNCHERS ---------------------------------
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf), -- Launch a Terminal
      ((modm, xK_space), spawn "rofi -show drun"),
      ((modm .|. shiftMask, xK_space), spawn "rofi -show window"),
      ((modm, xK_b), spawn "brave-browser-nightly"),
      ((modm .|. shiftMask, xK_b), spawn (myTerminal ++ " /usr/bin/bpytop")),
      ((modm .|. shiftMask, xK_e), spawn "rofimoji"),
      --------------------------------------------------------------------- WINDOWS ----------------------------------
      ((modm, xK_w), kill), --------------------------------------------- Close a Focused Window
      ((modm, xK_n), sendMessage NextLayout), ----------------------- Rotate through the avaliable layouts
      ((modm, xK_Tab), windows W.focusDown), ---------------------------- Move focus to next window
      ((modm, xK_j), windows W.focusDown), ------------------------------ Move focus to next window
      ((modm, xK_k), windows W.focusUp), -------------------------------- Move focus to previous window
      ((modm, xK_m), windows W.focusMaster), ---------------------------- Move focus to master window
      ((modm, xK_Return), windows W.swapMaster), ------------------------ SWAP FOCUSED WINDOW AND MASTER WINDOW
      ((modm .|. shiftMask, xK_j), windows W.swapDown), ----------------- SWAP FOCUSED WINDOW WITH NEXT WINDOW
      ((modm .|. shiftMask, xK_k), windows W.swapUp), ------------------- SWAP FOCUSED WINDOW WITH PREVIOUS WINDOW
      ((modm, xK_h), sendMessage Shrink), ------------------------------- Shrink master area size
      ((modm, xK_l), sendMessage Expand), ------------------------------- Expand master area size
      ((modm, xK_t), withFocused $ windows . W.sink), ------------------- Push window back into tiling
      ((modm, xK_comma), sendMessage (IncMasterN 1)), ------------------- Increment the number of windows in the master area
      ((modm, xK_period), sendMessage (IncMasterN (-1))), --------------- Decrement the number of windows in the master area

      --------------------------------------------------------------------- XMONAD ------------------------------------
      ((modm .|. shiftMask, xK_q), io (exitWith ExitSuccess)), ---------- Kill XMonad
      ((modm .|. shiftMask, xK_l), spawn "mantablockscreen"), ----------- Lock XMonad
      ((modm, xK_q), spawn "xmonad --recompile; xmonad --restart"), ----- Restart XMonad
      ((modm .|. shiftMask, xK_slash), spawn ("echo \"" ++ help ++ "\" | xmessage -file -")) -- Show Help Message with keybindings
    ]
      ++
      --
      -- mod-[1..9], Switch to workspace N
      -- mod-shift-[1..9], Move client to workspace N
      --
      [ ((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9],
          (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
      ]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) =
  M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ( (modm, button1),
        ( \w ->
            focus w >> mouseMoveWindow w
              >> windows W.shiftMaster
        )
      ),
      -- mod-button2, Raise the window to the top of the stack
      ((modm, button2), (\w -> focus w >> windows W.shiftMaster)),
      -- mod-button3, Set the window to floating mode and resize by dragging
      ( (modm, button3),
        ( \w ->
            focus w >> mouseResizeWindow w
              >> windows W.shiftMaster
        )
      )
      -- you may also bind events to the mouse scroll wheel (button4 and button5)
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
myLayout = avoidStruts (tiled ||| Mirror tiled ||| Full)
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled = spacing 10 $ Tall nmaster delta ratio

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio = 1 / 2

    -- Percent of screen to increment by when resizing panes
    delta = 3 / 100

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
myManageHook =
  composeAll
    [ className =? "MPlayer" --> doFloat,
      className =? "Gimp" --> doFloat,
      resource =? "desktop_window" --> doIgnore,
      resource =? "kdesktop" --> doIgnore
    ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook

--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook h = do
  fadeInactiveLogHook 1
  workspaceHistoryHook
    <+> dynamicLogWithPP
      xmobarPP
        { ppOutput = hPutStrLn h,
          ppCurrent = xmobarColor "#98be65" "" . wrap "[" "]", -- Current workspace in xmobar
          ppVisible = xmobarColor "#98be65" "", -- Visible but not current workspace
          ppHidden = xmobarColor "#82AAFF" "" . wrap "*" "", -- Hidden workspaces in xmobar
          ppHiddenNoWindows = xmobarColor "#c792ea" "", -- Hidden workspaces (no windows)
          ppTitle = xmobarColor "#b3afc2" "" . shorten 60, -- Title of active window in xmobar
          ppSep = "<fc=#666666> <fn=2>|</fn> </fc>", -- Separators in xmobar
          ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!", -- Urgent workspace
          ppOrder = \(ws : l : t : ex) -> [ws, l] ++ ex ++ [t]
        }

------------------------------------------------------------------------
-- Startup hook

myStartupHook =
  do
    spawnOnce "nitrogen --restore &"
    spawnOnce "picom &"
    spawnOnce "pulseaudio &"
    spawnOnce "xautolock -time 5 -locker \"$HOME/usr/local/bin/mantablockscreen\" -detectsleep &"
    spawnOnce "trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 --tint 0x282c34  --height 22 &"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
  xmproc <- spawnPipe "xmobar $HOME/.config/xmobar/xmobarrc"
  xmonad $
    docks
      defaultConfig
        { -- simple stuff
          terminal = myTerminal,
          focusFollowsMouse = myFocusFollowsMouse,
          clickJustFocuses = myClickJustFocuses,
          borderWidth = myBorderWidth,
          modMask = myModMask,
          workspaces = myWorkspaces,
          normalBorderColor = myNormalBorderColor,
          focusedBorderColor = myFocusedBorderColor,
          -- key bindings
          keys = myKeys,
          mouseBindings = myMouseBindings,
          -- hooks, layouts
          layoutHook = myLayout,
          manageHook = myManageHook,
          handleEventHook = myEventHook,
          logHook = myLogHook xmproc,
          startupHook = myStartupHook
        }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help =
  unlines
    [ "The default modifier key is 'alt'. Default keybindings:",
      "",
      "-- launching and killing programs",
      "mod-Shift-Enter  Launch xterminal",
      "mod-p            Launch dmenu",
      "mod-Shift-p      Launch gmrun",
      "mod-Shift-c      Close/kill the focused window",
      "mod-Space        Rotate through the available layout algorithms",
      "mod-Shift-Space  Reset the layouts on the current workSpace to default",
      "mod-n            Resize/refresh viewed windows to the correct size",
      "",
      "-- move focus up or down the window stack",
      "mod-Tab        Move focus to the next window",
      "mod-Shift-Tab  Move focus to the previous window",
      "mod-j          Move focus to the next window",
      "mod-k          Move focus to the previous window",
      "mod-m          Move focus to the master window",
      "",
      "-- modifying the window order",
      "mod-Return   Swap the focused window and the master window",
      "mod-Shift-j  Swap the focused window with the next window",
      "mod-Shift-k  Swap the focused window with the previous window",
      "",
      "-- resizing the master/slave ratio",
      "mod-h  Shrink the master area",
      "mod-l  Expand the master area",
      "",
      "-- floating layer support",
      "mod-t  Push window back into tiling; unfloat and re-tile it",
      "",
      "-- increase or decrease number of windows in the master area",
      "mod-comma  (mod-,)   Increment the number of windows in the master area",
      "mod-period (mod-.)   Deincrement the number of windows in the master area",
      "",
      "-- quit, or restart",
      "mod-Shift-q  Quit xmonad",
      "mod-q        Restart xmonad",
      "mod-[1..9]   Switch to workSpace N",
      "",
      "-- Workspaces & screens",
      "mod-Shift-[1..9]   Move client to workspace N",
      "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
      "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
      "",
      "-- Mouse bindings: default actions bound to mouse events",
      "mod-button1  Set the window to floating mode and move by dragging",
      "mod-button2  Raise the window to the top of the stack",
      "mod-button3  Set the window to floating mode and resize by dragging"
    ]
