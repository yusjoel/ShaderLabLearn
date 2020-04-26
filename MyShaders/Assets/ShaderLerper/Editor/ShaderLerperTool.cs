using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

public class ShaderLerperTool
{
    [MenuItem("Assets/Create Shander Lerper", true)]
    private static bool ValidateShader()
    {
        var shader = Selection.activeObject as Shader;
        if (shader == null)
            return false;

        return true;
    }

    [MenuItem("Assets/Create Shander Lerper")]
    private static void CreateShaderLerper()
    {
        var shader = Selection.activeObject as Shader;
        if (shader == null)
            return;

        //Debug.Log("Name: " + shader.name);

        var propertyNames = new List<string>();
        var colorProperties = new List<string>();
        var floatProperties = new List<string>();
        var textureProperties = new List<string>();

        int propertyCount = ShaderUtil.GetPropertyCount(shader);
        for (int i = 0; i < propertyCount; i++)
        {
            var shaderPropertyType = ShaderUtil.GetPropertyType(shader, i);
            string propertyName = ShaderUtil.GetPropertyName(shader, i);
            if (shaderPropertyType == ShaderUtil.ShaderPropertyType.TexEnv)
            {
                textureProperties.Add(propertyName);
                continue;
            }

            if (shaderPropertyType == ShaderUtil.ShaderPropertyType.Float ||
                shaderPropertyType == ShaderUtil.ShaderPropertyType.Range)
                floatProperties.Add(propertyName);
            else if(shaderPropertyType == ShaderUtil.ShaderPropertyType.Color)
                colorProperties.Add(propertyName);

            propertyNames.Add(propertyName);
        }

        string assetPath = AssetDatabase.GetAssetPath(shader);
        string directory = Path.GetDirectoryName(assetPath);
        if (directory == null) return;

        var go = new GameObject("Material Lerper");
        var lerper = go.AddComponent<MaterialLerper>();
        lerper.TextureProperties = textureProperties.ToArray();
        lerper.ColorProperties = colorProperties.ToArray();
        lerper.FloatProperties = floatProperties.ToArray();

        string fileName = Path.GetFileNameWithoutExtension(assetPath);

        // 创建插值器
        string lerperPrefabPath = directory + "/" + fileName + " Lerper.prefab";
        PrefabUtility.SaveAsPrefabAsset(go, lerperPrefabPath);
        Object.DestroyImmediate(go);

        // 创建插值版的Shader
        string lerperShaderPath = Path.Combine(directory, fileName + "Lerper.shader");
        using (var streamReader = new StreamReader(File.OpenRead(assetPath)))
        using (var streamWriter = new StreamWriter(File.Open(lerperShaderPath, FileMode.CreateNew)))
        {
            bool foundKeywordShader = false;
            bool replaceShaderName = false;
            bool foundKeywordSubShader = false;

            while (!streamReader.EndOfStream)
            {
                string line = streamReader.ReadLine();
                if (line == null) break;

                if (line.Trim().StartsWith("Shader"))
                    foundKeywordShader = true;

                if (foundKeywordShader && !replaceShaderName)
                    if (line.Contains(shader.name))
                    {
                        line = line.Replace(shader.name, shader.name + " (Lerper)");
                        replaceShaderName = true;
                    }

                if (line.Trim().StartsWith("SubShader"))
                    foundKeywordSubShader = true;

                string lerpToPropertyDefine = null;
                if (foundKeywordSubShader)
                    lerpToPropertyDefine = CreateLerpToPropertyDefine(line, propertyNames);

                if (string.IsNullOrEmpty(lerpToPropertyDefine))
                {
                    if(foundKeywordSubShader)
                        line = ReplaceVariableName(line, propertyNames);
                    streamWriter.WriteLine(line);
                }
                else
                {
                    streamWriter.WriteLine(line);
                    streamWriter.WriteLine(lerpToPropertyDefine);
                }
            }
        }
    }

    /// <summary>
    ///     将语句中对于属性的使用替换成宏LERP_PROP(prop)
    /// </summary>
    /// <param name="line"></param>
    /// <param name="propertyNames"></param>
    /// <returns></returns>
    private static string ReplaceVariableName(string line, List<string> propertyNames)
    {
        foreach (string propertyName in propertyNames)
            if (line.Contains(propertyName))
                line = line.Replace(propertyName, "LERP_PROP(" + propertyName + ")");

        return line;
    }

    /// <summary>
    ///     创建LerpTo后缀的变量定义
    ///     简单解析传入的语句, 如果是定义语句, 并且定义的变量在属性列表内, 返回LerpTo后缀的新变量定义
    ///     否则返回null
    /// </summary>
    /// <param name="line"></param>
    /// <param name="propertyNames"></param>
    private static string CreateLerpToPropertyDefine(string line, List<string> propertyNames)
    {
        // 检查该行是不是变量定义, 如果是的话获取类型, 并且增加LerpTo版本的定义
        // 定义应该类似于
        // float3 xxxxx; // xxxxxxx
        if (string.IsNullOrEmpty(line))
            return null;

        bool isComment = false;
        string variableType = null;
        var substrings = line.Trim().Split(' ');
        foreach (string substring in substrings)
        {
            if (substring == "//")
                break;

            if (substring == "/*")
            {
                isComment = true;
                continue;
            }

            if (isComment)
            {
                if (substring == "*/")
                    isComment = false;
                continue;
            }

            if (variableType == null)
            {
                if (IsValueType(substring))
                    variableType = substring;
                else
                    break;
            }
            else
            {
                string variableName = substring.Replace(";", "");
                if (propertyNames.Contains(variableName))
                    return line.Replace(variableName, variableName + "LerpTo");

                break;
            }
        }

        return null;
    }

    private static bool IsValueType(string s)
    {
        if (s == "float") return true;
        if (s == "float2") return true;
        if (s == "float3") return true;
        if (s == "float4") return true;

        if (s == "fixed") return true;
        if (s == "fixed2") return true;
        if (s == "fixed3") return true;
        if (s == "fixed4") return true;

        if (s == "half") return true;
        if (s == "half2") return true;
        if (s == "half3") return true;
        if (s == "half4") return true;

        return false;
    }
}
