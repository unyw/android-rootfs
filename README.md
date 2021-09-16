# android-rootfs
Alpine root filesystem used by the Unyw apk.  

## Build
LINUX REQUIRED.  
Be sure that `bash`, `tar`, `wget`, `realpath`, `md5sum`, `proot` and `qemu` (`qemu-aarch64-static` and `qemu-arm-static`) are avaiable on your system.
Then, just run: 
```bash
bash build.sh
```
Rootfs are created inside the `dist/` folder.
  
  
## License
Work in progress: the whole project hasn't a license model yet.  
Consider Unyw code to be released both under MIT and GPL 2 License.  
