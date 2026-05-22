#ifndef COLOR_UTILS_HLSL
#define COLOR_UTILS_HLSL

float GetLuminance(float3 rgb)
{
    return dot(saturate(rgb), float3(0.2126, 0.7152, 0.0722));
}

float3 AdjustSaturation(float3 rgb, float satMult)
{
    float lum = GetLuminance(rgb);
    satMult = max(0.0, satMult);
    return lerp(float3(lum, lum, lum), rgb, satMult);
}

float3 AdjustContrast(float3 rgb, float contrast)
{
    contrast = max(0.0, contrast);
    return saturate((rgb - 0.5) * contrast + 0.5);
}

float LerpHue(float hue1, float hue2, float alpha)
{
    float difference = frac(hue2 - hue1 + 0.5) - 0.5;
    return frac(hue1 + difference * alpha);
}

float3 LerpHSV(float3 hsv1, float3 hsv2, float alpha)
{
    return float3(
        LerpHue(hsv1.x, hsv2.x, alpha),
        lerp(hsv1.y, hsv2.y, alpha),
        lerp(hsv1.z, hsv2.z, alpha)
    );
}

// Unity Shader Graph wrappers
void GetLuminance_float(float3 rgb, out float luminance)
{
    luminance = GetLuminance(rgb);
}

void AdjustSaturation_float(float3 rgb, float saturation, out float3 result)
{
    result = AdjustSaturation(rgb, saturation);
}

void AdjustContrast_float(float3 rgb, float contrast, out float3 result)
{
    result = AdjustContrast(rgb, contrast);
}

void LerpHSV_float(float3 hsv1, float3 hsv2, float alpha, out float3 result)
{
    result = LerpHSV(hsv1, hsv2, alpha);
}

#endif 