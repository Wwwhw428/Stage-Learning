using UnityEngine;
using System;


[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class RadiusBlur : PostEffectsBase
{

    [Range(0.0f, 1.0f)]
    public float centerX = 0.5f;

    [Range(0.0f, 1.0f)]
    public float centerY = 0.5f;

    [Range(0.0f, 10.0f)]
    public float sampleDistance = 1.0f;

    [Range(0.0f, 10.0f)]
    public float sampleStrength = 1.0f;

    public Shader radialBlurShader = null;
    private Material radialBlurMaterial = null;


    public override bool CheckResources()
    {
        CheckSupport(false);

        radialBlurMaterial = CheckShaderAndCreateMaterial(radialBlurShader, radialBlurMaterial);

        if (!isSupported)
            ReportAutoDisable();
        return isSupported;
    }

    public void OnDisable()
    {
        if (radialBlurMaterial)
            DestroyImmediate(radialBlurMaterial);
    }

    public void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (CheckResources() == false)
        {
            Graphics.Blit(source, destination);
            return;
        }
        radialBlurMaterial.SetFloat("_CenterX", centerX);
        radialBlurMaterial.SetFloat("_CenterY", centerY);
        radialBlurMaterial.SetFloat("_SampleDistance", sampleDistance);
        radialBlurMaterial.SetFloat("_SampleStrength", sampleStrength);
        Graphics.Blit(source, destination, radialBlurMaterial, 0);
    }


    public void SetParam(float middleX = 0.5f, float middleY = 0.5f, float distance = 1.0f,float strength = 1.0f)
    {
        //centerX = middleX;
        //    centerY = middleY;
        //    sampleDistance = distance;
        //    sampleStrength = sampleStrength;
        Debug.Log(ValueLimitExcetension.ValueLimit(middleX, 0f, 1f));
        Debug.Log(ValueLimitExcetension.ValueLimit(middleY, 0f, 1f));
        Debug.Log(ValueLimitExcetension.ValueLimit(distance, 0f, 10f));
        Debug.Log(ValueLimitExcetension.ValueLimit(sampleStrength, 0f, 10f));
        this.centerX = ValueLimitExcetension.ValueLimit(middleX, 0f, 1f);
        this.centerY = ValueLimitExcetension.ValueLimit(middleY, 0f, 1f);
        this.sampleDistance = ValueLimitExcetension.ValueLimit(distance, 0f, 10f);
        this.sampleStrength = ValueLimitExcetension.ValueLimit(sampleStrength, 0f, 10f);
    }



}


public static partial class ValueLimitExcetension
{
    public static T ValueLimit<T>(T c, T min, T max) where T : IComparable
    {
        var a = (c.CompareTo(min) > 0) ? c : min;
        var b = (a.CompareTo(max) > 0) ? max : a;
        return b;
    }


    public static float ValueLimit(this float c, float min, float max)
    {
        return Math.Min(max, Math.Max(c, min));
    }

}

