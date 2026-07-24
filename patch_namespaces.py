import os
import re

def patch_namespaces():
    pub_cache = os.path.expanduser("~/.pub-cache/hosted/pub.dev")
    if not os.path.exists(pub_cache):
        pub_cache = os.environ.get("PUB_CACHE", "")
        if pub_cache:
            pub_cache = os.path.join(pub_cache, "hosted/pub.dev")
    
    if not pub_cache or not os.path.exists(pub_cache):
        print("PUB_CACHE not found.")
        return

    for item in os.listdir(pub_cache):
        plugin_dir = os.path.join(pub_cache, item)
        android_dir = os.path.join(plugin_dir, "android")
        if not os.path.isdir(android_dir):
            continue
            
        manifest = os.path.join(android_dir, "src", "main", "AndroidManifest.xml")
        build_gradle = os.path.join(android_dir, "build.gradle")
        build_gradle_kts = os.path.join(android_dir, "build.gradle.kts")
        
        if not os.path.exists(manifest):
            continue
            
        with open(manifest, "r", encoding="utf-8") as f:
            m = re.search(r'package\s*=\s*"([^"]+)"', f.read())
            if not m:
                continue
            pkg = m.group(1)
            
        for build_file in (build_gradle, build_gradle_kts):
            if os.path.exists(build_file):
                with open(build_file, "r", encoding="utf-8") as f:
                    content = f.read()
                
                if "namespace" not in content and "android {" in content:
                    print(f"Patching {item} ({pkg}) in {build_file}")
                    if build_file.endswith(".kts"):
                        new_content = content.replace("android {", f'android {{\n    namespace = "{pkg}"')
                    else:
                        new_content = content.replace("android {", f'android {{\n    namespace "{pkg}"')
                        
                    with open(build_file, "w", encoding="utf-8") as f:
                        f.write(new_content)

if __name__ == "__main__":
    patch_namespaces()
