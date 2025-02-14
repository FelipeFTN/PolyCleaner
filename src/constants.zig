pub const MAC_OS_CACHE_DIRS = [_]([]const u8){
    "$HOME/System/Library/Caches",
    "$HOME/private/var/folders",
    "$HOME/.bun/install/cache",
    "$HOME/go/pkg/mod/cache",
    "$HOME/private/var/tmp",
    "$HOME/Library/Caches",
    "$HOME/.npm/_cacache",
    "$HOME/private/tmp",
    "$HOME/.Trash",
};

pub const LINUX_CACHE_DIRS = [_]([]const u8){
    "$HOME/.var/app/com.google.Chrome/cache",
    "$HOME/.local/share/Trash",
    "$HOME/.bun/install/cache",
    "$HOME/go/pkg/mod/cache",
    "$HOME/.npm/_cacache",
    "$HOME/.cache",
};
