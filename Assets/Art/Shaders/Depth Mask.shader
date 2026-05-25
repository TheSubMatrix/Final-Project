Shader "Custom/DepthMask"
{
    Properties {}

    SubShader
    {
        Tags { "Queue" = "Geometry+1" }
        ColorMask 0
        ZWrite On

        Stencil
        {
            Ref 1
            Comp NotEqual
        }

        Pass {}
    }
}