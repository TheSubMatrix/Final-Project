inline float EaseIn(float interpolator){
    return interpolator * interpolator;
}
float EaseOut(float interpolator){
    return 1 - EaseIn(1 - interpolator);
}
float EaseInOut(float interpolator){
    float easeInValue = EaseIn(interpolator);
    float easeOutValue = EaseOut(interpolator);
    return lerp(easeInValue, easeOutValue, interpolator);
}
float Rand3DTo1D(float3 value, float3 dotDir = float3(12.9898, 78.233, 37.719)){
    float3 smallValue = cos(value);
    float random = dot(smallValue, dotDir);
    random = frac(sin(random) * 143758.5453);
    return random;
}
void ValueNoise3D_float(float3 value, out float noise)
{
    float interpolatorX = EaseInOut(frac(value.x));
    float interpolatorY = EaseInOut(frac(value.y));
    float interpolatorZ = EaseInOut(frac(value.z));

    float cellNoiseZ[2];
    [unroll]
    for (int z = 0; z <= 1; z++)
    {
        float cellNoiseY[2];
        [unroll]
        for (int y = 0; y <= 1; y++)
        {
            float cellNoiseX[2];
            [unroll]
            for (int x = 0; x <= 1; x++)
            {
                float3 cell = floor(value) + float3(x, y, z);
                cellNoiseX[x] = Rand3DTo1D(cell);
            }
            cellNoiseY[y] = lerp(cellNoiseX[0], cellNoiseX[1], interpolatorX);
        }
        cellNoiseZ[z] = lerp(cellNoiseY[0], cellNoiseY[1], interpolatorY);
    }

    noise = lerp(cellNoiseZ[0], cellNoiseZ[1], interpolatorZ);
}

void SimpleNoise3D_float(float3 uvw, float scale, out float noise)
{
    float n0, n1, n2;

    float freq0 = pow(2.0, 0.0);
    float amp0  = pow(0.5, 3.0 - 0.0);
    ValueNoise3D_float(uvw * scale / freq0, n0);

    float freq1 = pow(2.0, 1.0);
    float amp1  = pow(0.5, 3.0 - 1.0);
    ValueNoise3D_float(uvw * scale / freq1, n1);

    float freq2 = pow(2.0, 2.0);
    float amp2  = pow(0.5, 3.0 - 2.0);
    ValueNoise3D_float(uvw * scale / freq2, n2);

    noise = n0 * amp0 + n1 * amp1 + n2 * amp2;
}