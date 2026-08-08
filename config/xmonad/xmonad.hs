import XMonad
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Loggers
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP


main = xmonad
     $ docks
     $ ewmhFullscreen
     $ ewmh
     $ withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) defToggleStrutsKey
     $ defaults

defaults = def {
	    modMask = mod4Mask,
            terminal = "kitty",
            layoutHook = avoidStruts $ layoutHook def,
            manageHook = manageHook def <+> myManageHook,
            startupHook = startup
} `additionalKeysP` additionalKeyBindings

startup :: X ()
startup = do
        spawnOnce "picom -b"
        -- spawnOnce "trayer --edge top --align right --SetDockType true \
        --     \--SetPartialStrut true --expand true --width 10 --height 18 \
        --     \--transparent true --tint 0xfefefe"

myManageHook :: ManageHook
myManageHook = composeAll [
        -- resource =? "kdesktop"    --> doIgnore,
        -- title =? "plasmashell"    --> doIgnore,
        manageDocks ]

additionalKeyBindings = [
        ("M-S-p", spawn "rofi -show drun")]

myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = magenta " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap " " "" . xmobarBorder "Top" "#8be9fd" 2
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""

