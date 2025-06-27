fn main() {
    // 配置 Windows 资源文件
    #[cfg(target_os = "windows")]
    {
        use std::env;
        use std::path::Path;
        
        let mut res = winres::WindowsResource::new();
        
        // 设置图标
        let icon_path = Path::new("icons/icon.ico");
        if icon_path.exists() {
            res.set_icon_with_id("icons/icon.ico", "1");
        }
        
        // 设置版本信息
        res.set_version_info(winres::VersionInfo::PRODUCTVERSION, 0x0001000000000000);
        res.set_version_info(winres::VersionInfo::FILEVERSION, 0x0001000000000000);
        
        // 设置语言为简体中文
        res.set_language(0x0804); // 简体中文
        
        if let Err(e) = res.compile() {
            println!("cargo:warning=Failed to compile Windows resource: {}", e);
        }
    }
    
    tauri_build::build()
}
