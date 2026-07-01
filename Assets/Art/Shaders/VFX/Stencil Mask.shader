Shader "Custom/Stencil Mask"
{
    Properties
    {
        [IntRange] _StencilRef ("Stencil Ref", Range(0, 255)) = 0
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "Queue" = "Geometry-1"}
        Pass
        {
            
            ColorMask 0
            ZWrite Off
            
            Stencil
            {
                Ref [_StencilRef]
                Comp Always
                Pass Replace
            }
        }
        Pass
        {
            Tags{ "LightMode" = "DepthNormals"}
            ColorMask 0
            ZWrite Off
            Stencil
            {
                Ref [_StencilRef]
                Comp Always
                Pass Replace
            }
        }
    }
}
