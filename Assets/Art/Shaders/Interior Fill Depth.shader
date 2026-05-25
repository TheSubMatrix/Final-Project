Shader "Custom/Interior Depth"
{
    Properties {}

    SubShader
    {
        ColorMask 0
        Stencil
        {
            Ref 1
            Comp Always
            Pass Replace
        }

        Pass {}
    }
}