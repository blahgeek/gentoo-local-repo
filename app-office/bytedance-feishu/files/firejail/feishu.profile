# Firejail profile for feishu

include feishu.local
include globals.local

noblacklist ${HOME}/.config/LarkShell
mkdir ${HOME}/.config/LarkShell
whitelist ${HOME}/.config/LarkShell

# Redirect
include electron.profile
