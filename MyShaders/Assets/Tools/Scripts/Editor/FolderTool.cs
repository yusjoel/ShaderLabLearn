using System.IO;
using UnityEditor;
using UnityEngine;

public class FolderTool : MonoBehaviour {

    [MenuItem("Assets/Create Subfolders")]
    static void CreateMaterialByShader()
    {
        var folder = Selection.activeObject as DefaultAsset;
        if (folder == null)
            return;

        string assetPath = AssetDatabase.GetAssetPath(folder);
        if (!Directory.Exists(assetPath))
            Debug.LogFormat(folder, "{0} is not a folder.", assetPath);

        var subfolders = new[]
        {
            "Shaders", "Materials", "Textures", "Objects", "Scripts", "Scenes"
        };

        foreach (string subfolder in subfolders)
        {
            string path = Path.Combine(assetPath, subfolder);
            if(Directory.Exists(path)) continue;

            Directory.CreateDirectory(path);
        }

        AssetDatabase.Refresh();
    }
}
