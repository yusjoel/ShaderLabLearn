using System.IO;
using UnityEditor;
using UnityEngine;

namespace Tools.Editor
{
    public class ShaderTool : MonoBehaviour
    {
        [MenuItem("Assets/Create Material", true)]
        private static bool ValidateShader()
        {
            var shader = Selection.activeObject as Shader;
            if (shader == null)
                return false;

            return true;
        }

        [MenuItem("Assets/Create Material")]
        private static void CreateMaterialByShader()
        {
            var shader = Selection.activeObject as Shader;
            if (shader == null)
                return;

            string assetPath = AssetDatabase.GetAssetPath(shader);
            string directory = Path.GetDirectoryName(assetPath);
            if (directory == null) return;

            string fileName = Path.GetFileNameWithoutExtension(assetPath);
            string materialPath = Path.Combine(directory, fileName + ".mat");
            Material material;
            if (File.Exists(materialPath))
            {
                material = AssetDatabase.LoadAssetAtPath<Material>(materialPath);
                Debug.LogWarningFormat(material, "Material already exists.");
                return;
            }

            material = new Material(shader);
            AssetDatabase.CreateAsset(material, materialPath);
        }
    }
}
