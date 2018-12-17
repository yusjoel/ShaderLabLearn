using System.Collections;
using UnityEngine;

[RequireComponent(typeof(MaterialLerper))]
public class LerpDemo : MonoBehaviour
{
    public Material[] Materials;

    public Renderer[] Renderers;

    private MaterialLerper lerper;

    private bool isPlaying;

    private void Start()
    {
        lerper = GetComponent<MaterialLerper>();
    }

    private void OnGUI()
    {
        GUI.enabled = !isPlaying;
        var rect = new Rect(50, 50, 300, 50);
        foreach (var material in Materials)
        {
            if (GUI.Button(rect, material.name))
                StartCoroutine(LerpCustom(material, 3));

            rect.y += 60;
        }

        foreach (var material in Materials)
        {
            if (GUI.Button(rect, material.name + " (builtin)"))
                foreach (var r in Renderers)
                    StartCoroutine(LerpBuildIn(r, material, 3));

            rect.y += 60;
        }

        GUI.enabled = true;
    }

    private IEnumerator LerpCustom(Material material, float duration)
    {
        isPlaying = true;
        lerper.Duration = duration;
        lerper.Lerp(material);

        yield return new WaitForSeconds(duration);
        isPlaying = false;
    }

    private IEnumerator LerpBuildIn(Renderer r, Material end, float duration)
    {
        isPlaying = true;
        var start = r.sharedMaterial;
        var mat = new Material(start);
        r.material = mat;

        for (float t = 0; t < duration;)
        {
            r.material.Lerp(start, end, t / duration);
            t += Time.deltaTime;
            yield return null;
        }

        r.material = end;
        isPlaying = false;
    }
}
