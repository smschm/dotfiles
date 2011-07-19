--{{{ IMPORTS
import XMonad hiding ( (|||) )
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Data.List ( intercalate )
import XMonad.Actions.WindowBringer
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.LayoutModifier
import XMonad.Layout.FixedColumn
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ShowActive
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Spiral
import XMonad.Layout.Monitor
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.AppendFile
import XMonad.Prompt.Input
--import XMonad.Prompt.RunOrRaise
import XMonad.Util.Run
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import Control.Exception
import Control.Monad ( liftM, liftM2 ) -- hide this later
import XMonad.Actions.WindowGo ( runOrRaise )
import System.Directory (doesDirectoryExist, doesFileExist, executable, getPermissions)
import System.Posix.Process (executeFile, forkProcess, getAnyProcessStatus, createSession)
--}}}---
--{{{ BASIC SETTINGS
myTerminal      = "uxterm"
-- Width of the window border in pixels.
myBorderWidth   = 0
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
myModMask       = mod4Mask

-- The mask for the numlock key. Numlock status is "masked" from the
-- current modifier status, so the keybindings will work with numlock on or
-- off. You may need to change this on some systems.
--
-- You can find the numlock modifier by running "xmodmap" and looking for a
-- modifier with Num_Lock bound to it:
--
-- > $ xmodmap | grep Num
-- > mod2        Num_Lock (0x4d)
--
-- Set numlockMask = 0 if you don't have a numlock key, or want to treat
-- numlock status separately.
--
myNumlockMask   = mod2Mask
-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#333333"
myFocusedBorderColor = bee
--}}}---
--{{{ WORKSPACES
-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
--myWorkspaces    = words "i ii iii iv v vi vii viii ix"
wsTick = "^r(1x3)"
wsDash = "^r(3x3)"

ws0to4 = [[],[wsTick],[wsTick,wsTick],[wsTick,wsTick,wsTick],[wsTick,wsTick,wsTick,wsTick]]
wsSpec = (tail ws0to4) ++ map (wsDash :) ws0to4
--myWorkspaces = map (intercalate "^p(1)") wsSpec
--myWorkspaces = map (\x -> "^i(xbms/" ++ [x] ++ ".xbm)") ['1'..'9']

myWorkspaces    = map (\x -> [x]) $ ['1'..'9']
wsKeys = ([xK_1 .. xK_9] ++ [xK_a .. xK_z])
shMasks = (replicate 10 myModMask) ++ (replicate 26 controlMask)
--}}}---
--{{{ KEY BINDINGS
------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--

--openSurfAt :: String -> X ()
--openSurfAt uri = safeSpawn "surf" [uri]
openSurfPrefixed pref uri = safeSpawn "surf" [pref ++ uri]
openGoogAt = openSurfPrefixed "http://google.com/search?q="
--{{{ RORP
data RunOrRaisePrompt = RRP
instance XPrompt RunOrRaisePrompt where
    showXPrompt RRP = "Run or Raise: "

runOrRaisePrompt :: XPConfig -> X ()
runOrRaisePrompt c = do cmds <- io getCommands
                        mkXPrompt RRP c (getShellCompl cmds) open
open :: String -> X ()
open path = io (isNormalFile path) >>= \b ->
            if b
            then spawn $ "xdg-open \"" ++ path ++ "\""
            else uncurry runOrRaise . getTarget $ path
    
isNormalFile f = exists f >>= \e -> if e then notExecutable f else return False
exists f = fmap or $ sequence [doesFileExist f,doesDirectoryExist f]
notExecutable = fmap (not . executable) . getPermissions
getTarget x = (x,isApp x)

isApp :: String -> Query Bool
isApp "firefox"     = className =? "Firefox-bin"     <||> className =? "Firefox"
isApp "thunderbird" = className =? "Thunderbird-bin" <||> className =? "Thunderbird"
isApp x = liftM2 (==) pid $ pidof x

pidof :: String -> Query Int
pidof x = io $ (runProcessWithInput "pidof" [x] [] >>= readIO) `Prelude.catch` (\_ -> return 0)

pid :: Query Int
pid = ask >>= (\w -> liftX $ withDisplay $ \d -> getPID d w)
    where getPID d w = getAtom "_NET_WM_PID" >>= \a -> io $
                       liftM getPID' (getWindowProperty32 d a w)
          getPID' (Just (x:_)) = fromIntegral x
          getPID' (Just [])     = -1
          getPID' (Nothing)     = -1
--}}}
data KSP = KS
instance XPrompt KSP where
	showXPrompt KS = "oh noes: "
killscreen = do
	cmds <- io getCommands
	mkXPrompt KS defaultXPConfig (getShellCompl cmds) myOpen

myOpen path = io (isNormalFile path) >>= \b ->
	if b
	then spawn $ "xdg-open \"" ++ path ++ "\""
	else uncurry myROR . getTarget $ path
	
myROR path _ = spawn $ "xmessage ror: " ++ path
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- launch a terminal
    [ ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    , ((modMask .|. shiftMask, xK_backslash), spawn $ "uxterm -class DXTerm")

    -- launch dmenu
    --, ((modMask,               xK_p     ), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")
    --, ((modMask,               xK_p     ), runOrRaisePrompt defaultXPConfig)
    
	-- CRASH!
	--, ((modMask,               xK_c     ), spawn "xmessage butt" >> runOrRaise "" (liftM2 (==) (pidof "") pid))
	--, ((modMask,               xK_c     ), killscreen)
	--	, ((modMask,               xK_c     ), spawn $ "xdg-open \"\"")
	--, ((modMask,               xK_c     ), (io $ executeFile "/bin/sh" False ["-c", "xmessage qq \"\""] Nothing) >> return ())

    -- launch gmrun
    , ((modMask .|. shiftMask, xK_p     ), spawn "gmrun")
  --  , ((modMask .|. shiftMask, xK_g     ), gotoMenu)

    -- close focused window 
    , ((modMask .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modMask,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modMask,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modMask,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modMask,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modMask,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modMask,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modMask,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modMask,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modMask,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modMask              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modMask              , xK_period), sendMessage (IncMasterN (-1)))

    -- toggle the status bar gap
    -- TODO, update this binding with avoidStruts , ((modMask              , xK_b     ),

    -- Quit xmonad
    , ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modMask              , xK_q     ), restart "xmonad" True)

	-- add a note
    , ((modMask              , xK_d     ), appendFilePrompt defaultXPConfig "/home/steve/NOTES")
    --, ((modMask              , xK_o     ), inputPrompt defaultXPConfig "surf" ?+ openSurfAt)
    , ((modMask              , xK_o     ), spawn "surf")
    , ((modMask              , xK_g     ), inputPrompt defaultXPConfig "google" ?+ openGoogAt)
    --, ((modMask              , xK_g     ), spawn "surf google.com")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modMask .|. mk , k), windows $ f i)
        | (i, k, mk) <- zip3 (XMonad.workspaces conf) wsKeys shMasks
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    {-
	[((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_0 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++-}

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_v, xK_w] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

--}}}---
--{{{ MOUSE BINDINGS
------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]
--}}}
--{{{ MONITOR (keep on top)
--------------- monitor: keep a dzen on top:
myMonitor = monitor {
	prop = Name "dzen title",
	rect = Rectangle 0 0 80 5
}
--}}}
--{{{ LAYOUTS
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
myLayout = {- ModifiedLayout myMonitor $ -} avoidStruts $ showActive' defaultSAConfig {sa_blob_size = 24, sa_act_color = "#cc3333", sa_inact_color = "#000000"} $ {-(tiled ****//* Full) ||| -} tiled ||| Mirror tiled ||| fcol ||| Full ||| spiral ratio ||| ThreeColMid nmaster delta ratio
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
     fcol = FixedColumn nmaster 10 80 10

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 1/60
---}}}
--{{{ WINDOW RULES
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
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Xmessage" --> doFloat
    --, className =? "Gimp"           --> doFloat
--	, (stringProperty "WM_NAME") =? "dzen title" --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True
--}}}
--{{{ DZEN
------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--
myLogHook = dynamicLogWithPP myPP -- --$ return ()

bee = "#ffee22"
--defBG = "#000000"
defBG = "#eeeeee"
--defFG = "#0011dd"
defFG = "#333333"
redFG = "#77dd33"
actFG = "#000000" --"#ffffff"
greenBG = "#ffffff" -- bee --"#ccbb66"
inactFG = "#444444"
inactBG = "#bbbbbb"
lighterFG = "#333333"

myPad x = "^p(4)" ++ x ++ "^p(4)"

myPP = dzenPP {
	ppCurrent = dzenColor actFG greenBG . myPad . pad,
	ppHidden = dzenColor inactFG inactBG . myPad .  pad,
	ppVisible = dzenColor greenBG inactBG . myPad . pad, -- unused w/ 1 monitor
	ppHiddenNoWindows = const "",
	ppUrgent = dzenColor "black" "red" . ((myPad "!") ++),
	ppWsSep = dzenColor "#aaaaaa" "#aaaaaa" "^p(1)",
	ppSep = dzenColor "#aaaaaa" "#aaaaaa" "^p(1)",--,zenColor lighterFG  defBG "^r(1x8)",
	ppLayout = dzenColor actFG greenBG . myPad . (
		-- . (++ dzenColor lighterFG defBG "^p(4)^r(1x8)"). (
		\x -> case x of
			"Tall" -> "[]="
			"Mirror Tall" -> "TTT"
			"Full" -> "[_]"
			"FixedColumn" -> "|=="
			"Spiral" -> "/_>"
			"ThreeCol" -> "=|="
			_ -> pad x
		{-	"Tall" -> "^i(xbms/btall.xbm)"
			"Mirror Tall" -> "^i(xbms/bmtall.xbm)"
			"FixedColumn" -> "^i(xbms/bfcol.xbm)"
			"Full" -> "^i(xbms/bfull.xbm)"
			"Spiral" -> "^i(xbms/bspiral.xbm)"
			_ -> pad x-}
		),
	ppTitle = ("\n2 " ++) . dzenColor "#333333" "#eeeeee" . myPad . dzenEscape -- const ""-- (' ':) . dzenEscape
	,ppOutput = putStrLn . ("0 "++) -- for dplex
} where pad x = "^p(1)" ++ x ++ "^p(1)"
--}}}
--{{{ OTHER
------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = setWMName "LG3D" -- needed for matlab

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = xmonad $ withUrgencyHook NoUrgencyHook $ defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will 
-- use the defaults defined in xmonad/XMonad/Config.hs
-- 
-- No need to modify this.
--
defaults = defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        numlockMask        = myNumlockMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook <+> manageMonitor myMonitor,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }
--}}}
