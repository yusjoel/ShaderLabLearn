# MaterialPropertyDrawer
* <https://docs.unity3d.com/ScriptReference/MaterialPropertyDrawer.html>
* <https://github.com/Unity-Technologies/UnityCsReference/blob/master/Editor/Mono/EditorGUI.cs>

## 内建属性
* Toggle
* Enum
* KeywordEnum
* PowerSlider
   * min, max, value会被映射为Power(n, 1 / power)
   * 获得的值再被映射为Power(n ,power)
   * 参考EditorGUI.DoSlider(...)
* IntRange
* Space
* Header