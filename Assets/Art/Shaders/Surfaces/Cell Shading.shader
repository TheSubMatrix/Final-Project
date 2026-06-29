// Stencil Injection by ShaderGraphStencilInjector

Shader "Stencil Shader Graph/Cell Shading"
{
Properties
{
_Transition_Sharpness("Transition Sharpness", Float) = 0.7
_Posterization("Posterization", Float) = 12
_Posterization_Sharpness("Posterization Sharpness", Float) = 0.5
_Rim_Light("Rim Light", Range(0, 1)) = 0
[NoScaleOffset]_Base("Base", 2D) = "white" {}
_Color("Color", Color) = (1, 1, 1, 1)
[Normal][NoScaleOffset]_Normal("Normal", 2D) = "bump" {}
[NoScaleOffset]_Metallic_Smoothness("Metallic / Smoothness", 2D) = "black" {}
[NoScaleOffset]_Emissive("Emissive", 2D) = "black" {}
_Emissive_Intensity("Emissive Intensity", Float) = 1
[Toggle(_MAIN_LIGHT_SHADOWS)]_MAIN_LIGHT_SHADOWS("Main Light Shadows", Float) = 1
[Toggle(_MAIN_LIGHT_SHADOWS_CASCADE)]_MAIN_LIGHT_SHADOWS_CASCADE("Main Light Shadows Cascade", Float) = 1
[Toggle(_SHADOWS_SOFT)]_SHADOWS_SOFT("Shadows Soft", Float) = 1
[Toggle(_ADDITIONAL_LIGHTS)]_ADDITIONAL_LIGHTS("Additional Lights", Float) = 1
[Toggle(_ADDITIONAL_LIGHT_SHADOWS)]_ADDITIONAL_LIGHT_SHADOWS("Additional Light Shadows", Float) = 1
[Toggle(_CLUSTER_LIGHT_LOOP)]_CLUSTER_LIGHT_LOOP("Cluster Light Loop", Float) = 1
[Toggle(_LIGHTMAP_SHADOW_MIXING)]_LIGHTMAP_SHADOW_MIXING("Lightmap Shadow Mixing", Float) = 1
[Toggle(_SHADOW_MASKS)]_SHADOW_MASKS("Shadow Masks", Float) = 1
[Toggle(_REFLECTION_PROBE_ATLAS)]_REFLECTION_PROBE_ATLAS("Reflection Probe Atlas", Float) = 1
[Toggle(_REFLECTION_PROBE_BOX_PROJECTION)]_REFLECTION_PROBE_BOX_PROJECTION("Reflection Probe Box Projection", Float) = 1
[Toggle(_REFLECTION_PROBE_BLENDING)]_REFLECTION_PROBE_BLENDING("Reflection Probe Blending", Float) = 1
[HideInInspector]_CastShadows("_CastShadows", Float) = 1
[HideInInspector]_Surface("_Surface", Float) = 0
[HideInInspector]_Blend("_Blend", Float) = 0
[HideInInspector]_AlphaClip("_AlphaClip", Float) = 0
[HideInInspector]_SrcBlend("_SrcBlend", Float) = 1
[HideInInspector]_DstBlend("_DstBlend", Float) = 0
[HideInInspector]_SrcBlendAlpha("_SrcBlendAlpha", Float) = 1
[HideInInspector]_DstBlendAlpha("_DstBlendAlpha", Float) = 0
[HideInInspector][ToggleUI]_ZWrite("_ZWrite", Float) = 1
[HideInInspector]_ZWriteControl("_ZWriteControl", Float) = 0
[HideInInspector]_ZTest("_ZTest", Float) = 4
[HideInInspector]_Cull("_Cull", Float) = 2
[HideInInspector]_AlphaToMask("_AlphaToMask", Float) = 0
[HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
[HideInInspector]_QueueControl("_QueueControl", Float) = -1

        // Stencil Properties
        [IntRange] _StencilRef ("Stencil Reference Value", Range(0, 255)) = 0
        [IntRange] _StencilReadMask ("Stencil ReadMask Value", Range(0, 255)) = 255
        [IntRange] _StencilWriteMask ("Stencil WriteMask Value", Range(0, 255)) = 255
        [Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp ("Stencil Comparison", Float) = 0
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilPass ("Stencil Pass Op", Float) = 0
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilFail ("Stencil Fail Op", Float) = 0
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilZFail ("Stencil ZFail Op", Float) = 0
        [Enum(Off,0,On,1)] _StencilEnabled ("Stencil Enabled", Float) = 0
}
SubShader
{
Tags
{
"RenderPipeline"="UniversalPipeline"
"RenderType"="Opaque"
"UniversalMaterialType" = "Unlit"
"Queue"="Geometry"
"DisableBatching"="False"
"ShaderGraphShader"="true"
"ShaderGraphTargetId"="UniversalUnlitSubTarget"
}
Pass
{
    Name "Universal Forward"
    Tags
    {
        // LightMode: <None>
    }

// Render State
Cull [_Cull]
Blend [_SrcBlend] [_DstBlend], [_SrcBlendAlpha] [_DstBlendAlpha]
ZTest [_ZTest]
ZWrite [_ZWrite]
AlphaToMask [_AlphaToMask]

        // Stencil Buffer Setup
        Stencil
        {
            Ref [_StencilRef]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
            Comp [_StencilComp]
            Pass [_StencilPass]
            Fail [_StencilFail]
            ZFail [_StencilZFail]
        }

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 2.0
#pragma multi_compile_instancing
#pragma instancing_options renderinglayer
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma multi_compile _ LIGHTMAP_ON
#pragma multi_compile _ DIRLIGHTMAP_COMBINED
#pragma multi_compile _ USE_LEGACY_LIGHTMAPS
#pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
#pragma multi_compile_fragment _ DEBUG_DISPLAY
#pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
#pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
#pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
#pragma shader_feature_local_fragment _ _ALPHAMODULATE_ON
#pragma shader_feature_local_fragment _ _ALPHATEST_ON
#pragma multi_compile_local _ _MAIN_LIGHT_SHADOWS
#pragma multi_compile_local _ _ADDITIONAL_LIGHT_SHADOWS
#pragma multi_compile_local _ _MAIN_LIGHT_SHADOWS_CASCADE
#pragma multi_compile_local _ _SHADOWS_SOFT
#pragma multi_compile_local _ _ADDITIONAL_LIGHTS
#pragma multi_compile_local _ _LIGHTMAP_SHADOW_MIXING
#pragma multi_compile_local _ _SHADOW_MASKS
#pragma multi_compile_local _ _CLUSTER_LIGHT_LOOP
#pragma multi_compile_local _ _REFLECTION_PROBE_ATLAS
#pragma multi_compile_local _ _REFLECTION_PROBE_BOX_PROJECTION
#pragma multi_compile_local _ _REFLECTION_PROBE_BLENDING



// Defines

#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_TEXCOORD2
#define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
#define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
#define VARYINGS_NEED_POSITION_WS
#define VARYINGS_NEED_NORMAL_WS
#define VARYINGS_NEED_TANGENT_WS
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_TEXCOORD2
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_UNLIT
#define _FOG_FRAGMENT 1
#define UNLIT_DEFAULT_DECAL_BLENDING 1
#define UNLIT_DEFAULT_SSAO 1


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 uv2 : TEXCOORD2;
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 positionWS;
 float3 normalWS;
 float4 tangentWS;
 float4 texCoord0;
 float4 texCoord1;
 float4 texCoord2;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float3 WorldSpaceNormal;
 float3 TangentSpaceNormal;
 float3 WorldSpaceTangent;
 float3 WorldSpaceBiTangent;
 float3 WorldSpaceViewDirection;
 float3 ObjectSpacePosition;
 float3 WorldSpacePosition;
 float3 AbsoluteWorldSpacePosition;
 float2 NDCPosition;
 float2 PixelPosition;
 float4 uv0;
 float4 uv1;
 float4 uv2;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float4 tangentWS : INTERP0;
 float4 texCoord0 : INTERP1;
 float4 texCoord1 : INTERP2;
 float4 texCoord2 : INTERP3;
 float3 positionWS : INTERP4;
 float3 normalWS : INTERP5;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.tangentWS.xyzw = input.tangentWS;
output.texCoord0.xyzw = input.texCoord0;
output.texCoord1.xyzw = input.texCoord1;
output.texCoord2.xyzw = input.texCoord2;
output.positionWS.xyz = input.positionWS;
output.normalWS.xyz = input.normalWS;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
output.tangentWS = input.tangentWS.xyzw;
output.texCoord0 = input.texCoord0.xyzw;
output.texCoord1 = input.texCoord1.xyzw;
output.texCoord2 = input.texCoord2.xyzw;
output.positionWS = input.positionWS.xyz;
output.normalWS = input.normalWS.xyz;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
float _Transition_Sharpness;
float _Posterization;
float _Posterization_Sharpness;
float _Rim_Light;
float4 _Base_TexelSize;
float4 _Normal_TexelSize;
float4 _Color;
float4 _Metallic_Smoothness_TexelSize;
float4 _Emissive_TexelSize;
float _Emissive_Intensity;
UNITY_TEXTURE_STREAMING_DEBUG_VARS;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_Base);
SAMPLER(sampler_Base);
TEXTURE2D(_Normal);
SAMPLER(sampler_Normal);
TEXTURE2D(_Metallic_Smoothness);
SAMPLER(sampler_Metallic_Smoothness);
TEXTURE2D(_Emissive);
SAMPLER(sampler_Emissive);

// Graph Includes
#include_with_pragmas "Assets/Art/Shaders/Custom Lighting/Components/Debug/DebugLightingComplexity.hlsl"

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Divide_half(half A, half B, out half Out)
{
    Out = A / B;
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_OneMinus_half(half In, out half Out)
{
    Out = 1 - In;
}

void Unity_Multiply_float_float(float A, float B, out float Out)
{
Out = A * B;
}

void Unity_Multiply_half_half(half A, half B, out half Out)
{
Out = A * B;
}

// unity-custom-func-begin
void ApplyDecals_float(float4 positionCS, float3 baseColor, float3 specularColor, float3 normalWS, float metallic, float smoothness, float occlusion, out float3 baseColorOut, out float3 specularColorOut, out float3 normalWSOut, out float metallicOut, out float smoothnessOut, out float occlusionOut){
#if !defined(SHADERGRAPH_PREVIEW) && defined(_DBUFFER)
	ApplyDecal(positionCS, baseColor, specularColor, normalWS, metallic, occlusion, smoothness);
	baseColorOut = baseColor;
	specularColorOut = specularColor;
	normalWSOut = normalWS;
	metallicOut = metallic;
	occlusionOut = occlusion;
	smoothnessOut = smoothness;
#else
	baseColorOut = baseColor;
	specularColorOut = specularColor;
	normalWSOut = normalWS;
	metallicOut = metallic;
	occlusionOut = occlusion;
	smoothnessOut = smoothness;
#endif
}
// unity-custom-func-end

struct Bindings_ApplyDecals_66e8fc89f7971da4c8964580a0eb9f80_float
{
float2 PixelPosition;
};

void SG_ApplyDecals_66e8fc89f7971da4c8964580a0eb9f80_float(float3 _Base_Color, float3 _NormalWS, float _Metallic, float _Smoothness, float _AmbientOcclusion, Bindings_ApplyDecals_66e8fc89f7971da4c8964580a0eb9f80_float IN, out float3 BaseColor_1, out float3 SpecularColor_2, out float3 NormalWS_3, out float Metallic_4, out float Smoothness_6, out float AmbientOcclusion_5)
{
float4 _ScreenPosition_475ffbde1b774459b0d45276e537a836_Out_0_Vector4 = float4(IN.PixelPosition.xy, 0, 0);
float _Split_ad27d29658ef44f7b6941c97694d6866_R_1_Float = _ScreenPosition_475ffbde1b774459b0d45276e537a836_Out_0_Vector4[0];
float _Split_ad27d29658ef44f7b6941c97694d6866_G_2_Float = _ScreenPosition_475ffbde1b774459b0d45276e537a836_Out_0_Vector4[1];
float _Split_ad27d29658ef44f7b6941c97694d6866_B_3_Float = _ScreenPosition_475ffbde1b774459b0d45276e537a836_Out_0_Vector4[2];
float _Split_ad27d29658ef44f7b6941c97694d6866_A_4_Float = _ScreenPosition_475ffbde1b774459b0d45276e537a836_Out_0_Vector4[3];
float _Divide_3f9fb3b7b5b94d0d8246bbc34aa63f7b_Out_2_Float;
Unity_Divide_float(_Split_ad27d29658ef44f7b6941c97694d6866_G_2_Float, _ScreenParams.y, _Divide_3f9fb3b7b5b94d0d8246bbc34aa63f7b_Out_2_Float);
float _OneMinus_3cfec48ba27f4585a5feb790836dc9dc_Out_1_Float;
Unity_OneMinus_float(_Divide_3f9fb3b7b5b94d0d8246bbc34aa63f7b_Out_2_Float, _OneMinus_3cfec48ba27f4585a5feb790836dc9dc_Out_1_Float);
float _Multiply_a4baed73797c41c1b9631ae9bbddfe12_Out_2_Float;
Unity_Multiply_float_float(_OneMinus_3cfec48ba27f4585a5feb790836dc9dc_Out_1_Float, _ScreenParams.y, _Multiply_a4baed73797c41c1b9631ae9bbddfe12_Out_2_Float);
float2 _Vector2_eed86f79e1de4c188df97eb091955bc5_Out_0_Vector2 = float2(_Split_ad27d29658ef44f7b6941c97694d6866_R_1_Float, _Multiply_a4baed73797c41c1b9631ae9bbddfe12_Out_2_Float);
float3 _Property_6219e38e66a84dddb55188eb0359a8c3_Out_0_Vector3 = _Base_Color;
float3 _Property_f4c37d8281c1497e8dab743349080d88_Out_0_Vector3 = _NormalWS;
float _Property_0826181079c84604befc19a2460f4daa_Out_0_Float = _Metallic;
float _Property_d54a743184cc4f27b93d5f5b239c7b7e_Out_0_Float = _Smoothness;
float _Property_bd6cbdae9db240b9b4ad935655106f79_Out_0_Float = _AmbientOcclusion;
float3 _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_baseColorOut_8_Vector3;
float3 _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_specularColorOut_9_Vector3;
float3 _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_normalWSOut_10_Vector3;
float _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_metallicOut_11_Float;
float _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_smoothnessOut_13_Float;
float _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_occlusionOut_12_Float;
ApplyDecals_float((float4(_Vector2_eed86f79e1de4c188df97eb091955bc5_Out_0_Vector2, 0.0, 1.0)), _Property_6219e38e66a84dddb55188eb0359a8c3_Out_0_Vector3, float3 (0, 0, 0), _Property_f4c37d8281c1497e8dab743349080d88_Out_0_Vector3, _Property_0826181079c84604befc19a2460f4daa_Out_0_Float, _Property_d54a743184cc4f27b93d5f5b239c7b7e_Out_0_Float, _Property_bd6cbdae9db240b9b4ad935655106f79_Out_0_Float, _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_baseColorOut_8_Vector3, _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_specularColorOut_9_Vector3, _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_normalWSOut_10_Vector3, _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_metallicOut_11_Float, _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_smoothnessOut_13_Float, _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_occlusionOut_12_Float);
BaseColor_1 = _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_baseColorOut_8_Vector3;
SpecularColor_2 = _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_specularColorOut_9_Vector3;
NormalWS_3 = _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_normalWSOut_10_Vector3;
Metallic_4 = _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_metallicOut_11_Float;
Smoothness_6 = _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_smoothnessOut_13_Float;
AmbientOcclusion_5 = _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_occlusionOut_12_Float;
}

// unity-custom-func-begin
void SwitchLightingDebug_float(float3 BaseColorIn, float3 NormalIn, float MetallicIn, float SmoothnessIn, float3 EmissionIn, float AmbientOcclusionIn, float3 positionWS, float3 bakedGI, out float3 BaseColorOut, out float3 NormalOut, out float MetallicOut, out float SmoothnessOut, out float3 EmissionOut, out float AmbientOcclusionOut){
#if !defined(SHADERGRAPH_PREVIEW) && defined(DEBUG_DISPLAY)

[branch] switch(int(_DebugLightingMode))

{

    case 0: //none

		BaseColorOut = BaseColorIn;

		MetallicOut = MetallicIn;

		SmoothnessOut = SmoothnessIn;

		NormalOut = NormalIn;

		EmissionOut = EmissionIn;

		AmbientOcclusionOut = AmbientOcclusionIn;

		break;

    case 1: //SHADOW_CASCADES

		half cascadeIndex = ComputeCascadeIndex(positionWS);

		switch (uint(cascadeIndex))

		{

			case 0: BaseColorOut = kDebugColorShadowCascade0.rgb;break;

			case 1: BaseColorOut = kDebugColorShadowCascade1.rgb;break;

			case 2: BaseColorOut = kDebugColorShadowCascade2.rgb;break;

			case 3: BaseColorOut = kDebugColorShadowCascade3.rgb;break;

			default: BaseColorOut = kDebugColorBlack.rgb;break;

		}

		MetallicOut = MetallicIn;

		SmoothnessOut = SmoothnessIn;

		NormalOut = NormalIn;

		EmissionOut = EmissionIn;

		AmbientOcclusionOut = AmbientOcclusionIn;

		break;

    case 2: //LIGHTING_WITHOUT_NORMAL_MAPS

		BaseColorOut = float3(1,1,1);

		MetallicOut = 0;

		SmoothnessOut = 0;

		NormalOut = float3(0,0,1);

		EmissionOut = float3(0,0,0);

		AmbientOcclusionOut = 1;

		break;

    case 3: //LIGHTING_WITH_NORMAL_MAPS

		BaseColorOut = float3(1,1,1);

		MetallicOut = 0;

		SmoothnessOut = 0;

		NormalOut = NormalIn;

		EmissionOut = float3(0,0,0);

		AmbientOcclusionOut = 1;

		break;

    case 4: //REFLECTIONS

		BaseColorOut = float3(0.1,0.1,0.1);

		MetallicOut = 1;

		SmoothnessOut = 1;

		NormalOut = float3(0,0,1);

		EmissionOut = float3(0,0,0);

		AmbientOcclusionOut = 1;

		break;

    case 5: //REFLECTIONS_WITH_SMOOTHNESS

		BaseColorOut = float3(0.1,0.1,0.1);

		MetallicOut = 1;

		SmoothnessOut = SmoothnessIn;

		NormalOut = NormalIn;

		EmissionOut = float3(0,0,0);

		AmbientOcclusionOut = AmbientOcclusionIn;

		break;

    case 6: //GLOBAL_ILLUM

		BaseColorOut = bakedGI;

		MetallicOut = MetallicIn;

		SmoothnessOut = 0;

		NormalOut = float3(0,0,1);

		EmissionOut = float3(0,0,0);

		AmbientOcclusionOut = 1;

		break;

    default:

		BaseColorOut = BaseColorIn;

		MetallicOut = MetallicIn;

		SmoothnessOut = SmoothnessIn;

		NormalOut = NormalIn;

		EmissionOut = EmissionIn;

		AmbientOcclusionOut = AmbientOcclusionIn;

		break;

}

#else

		BaseColorOut = BaseColorIn;

		MetallicOut = MetallicIn;

		SmoothnessOut = SmoothnessIn;

		NormalOut = NormalIn;

		EmissionOut = EmissionIn;

		AmbientOcclusionOut = AmbientOcclusionIn;

#endif
}
// unity-custom-func-end

struct Bindings_DebugLighting_61e571d2b9ede1240a524a849d20c997_float
{
float3 WorldSpaceNormal;
float3 WorldSpaceTangent;
float3 WorldSpaceBiTangent;
float3 WorldSpacePosition;
float2 PixelPosition;
half4 uv1;
half4 uv2;
};

void SG_DebugLighting_61e571d2b9ede1240a524a849d20c997_float(float3 _Base_Color, float3 _NormalWS, float _Metallic, float _Smoothness, float3 _Emission, float _AmbientOcclusion, Bindings_DebugLighting_61e571d2b9ede1240a524a849d20c997_float IN, out float3 BaseColor_1, out float3 Normal_4, out float Metallic_2, out float Smoothness_3, out float3 Emission_5, out float AmbientOcclusion_6)
{
float3 _Property_501515703e3a4a1dbd19f4ae273add46_Out_0_Vector3 = _Base_Color;
float3 _Property_e5bcb5bf3b62412b8983e3aa1ada8fcd_Out_0_Vector3 = _NormalWS;
float3 _Transform_13c6b1e888d440fd8340d4a7138979ba_Out_1_Vector3;
{
float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
_Transform_13c6b1e888d440fd8340d4a7138979ba_Out_1_Vector3 = TransformWorldToTangent(_Property_e5bcb5bf3b62412b8983e3aa1ada8fcd_Out_0_Vector3.xyz, tangentTransform, true);
}
float _Property_7a450453146043b2b11397a72c325042_Out_0_Float = _Metallic;
float _Property_f0326121e031478a90610d60b8321364_Out_0_Float = _Smoothness;
float3 _Property_491d95b34bb245718ee21bff5fc249cd_Out_0_Vector3 = _Emission;
float _Property_da91a6effd53499db08bb774d5686c68_Out_0_Float = _AmbientOcclusion;
float3 _BakedGI_3f01c30cb8b64e9d9f7fbe474622c7dc_Out_1_Vector3 = SHADERGRAPH_BAKED_GI(IN.WorldSpacePosition, _Property_e5bcb5bf3b62412b8983e3aa1ada8fcd_Out_0_Vector3, IN.PixelPosition.xy, IN.uv1.xy, IN.uv2.xy, true);
float3 _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_BaseColorOut_7_Vector3;
float3 _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_NormalOut_11_Vector3;
float _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_MetallicOut_9_Float;
float _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_SmoothnessOut_10_Float;
float3 _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_EmissionOut_12_Vector3;
float _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_AmbientOcclusionOut_13_Float;
SwitchLightingDebug_float(_Property_501515703e3a4a1dbd19f4ae273add46_Out_0_Vector3, _Transform_13c6b1e888d440fd8340d4a7138979ba_Out_1_Vector3, _Property_7a450453146043b2b11397a72c325042_Out_0_Float, _Property_f0326121e031478a90610d60b8321364_Out_0_Float, _Property_491d95b34bb245718ee21bff5fc249cd_Out_0_Vector3, _Property_da91a6effd53499db08bb774d5686c68_Out_0_Float, IN.WorldSpacePosition, _BakedGI_3f01c30cb8b64e9d9f7fbe474622c7dc_Out_1_Vector3, _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_BaseColorOut_7_Vector3, _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_NormalOut_11_Vector3, _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_MetallicOut_9_Float, _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_SmoothnessOut_10_Float, _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_EmissionOut_12_Vector3, _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_AmbientOcclusionOut_13_Float);
BaseColor_1 = _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_BaseColorOut_7_Vector3;
Normal_4 = _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_NormalOut_11_Vector3;
Metallic_2 = _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_MetallicOut_9_Float;
Smoothness_3 = _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_SmoothnessOut_10_Float;
Emission_5 = _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_EmissionOut_12_Vector3;
AmbientOcclusion_6 = _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_AmbientOcclusionOut_13_Float;
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

void Unity_Add_float(float A, float B, out float Out)
{
    Out = A + B;
}

void Unity_Add_half(half A, half B, out half Out)
{
    Out = A + B;
}

void Unity_Reciprocal_float(float In, out float Out)
{
    Out = 1.0/In;
}

void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
{
    Out = pow((1.0 - saturate(dot(normalize(Normal), ViewDir))), Power);
}

void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
{
    Out = lerp(A, B, T);
}

struct Bindings_ReflectanceURP_57a8ea7c8f931c941b2bb57aedc451aa_float
{
float3 WorldSpaceNormal;
float3 WorldSpaceViewDirection;
};

void SG_ReflectanceURP_57a8ea7c8f931c941b2bb57aedc451aa_float(float3 _Base_Color, float3 _NormalWS, bool _NormalWS_3240674a787044a092398b1ca753ad83_IsConnected, float _Metallic, float _Smoothness, float _F0, Bindings_ReflectanceURP_57a8ea7c8f931c941b2bb57aedc451aa_float IN, out float3 Reflectance_1)
{
float _Property_4678b902494b4e1a9b08a8067b7bed85_Out_0_Float = _Smoothness;
float _OneMinus_0aa2823e9b1a4726bd6382418b3e6a87_Out_1_Float;
Unity_OneMinus_float(_Property_4678b902494b4e1a9b08a8067b7bed85_Out_0_Float, _OneMinus_0aa2823e9b1a4726bd6382418b3e6a87_Out_1_Float);
float _Multiply_314f6a0aec0a44538333e69617e91cf9_Out_2_Float;
Unity_Multiply_float_float(_OneMinus_0aa2823e9b1a4726bd6382418b3e6a87_Out_1_Float, _OneMinus_0aa2823e9b1a4726bd6382418b3e6a87_Out_1_Float, _Multiply_314f6a0aec0a44538333e69617e91cf9_Out_2_Float);
float _Add_513724b99c2f4ea2a803e64d80f0c25b_Out_2_Float;
Unity_Add_float(_Multiply_314f6a0aec0a44538333e69617e91cf9_Out_2_Float, float(1), _Add_513724b99c2f4ea2a803e64d80f0c25b_Out_2_Float);
float _Reciprocal_67b338305d0043abb9e7d82dd0f16146_Out_1_Float;
Unity_Reciprocal_float(_Add_513724b99c2f4ea2a803e64d80f0c25b_Out_2_Float, _Reciprocal_67b338305d0043abb9e7d82dd0f16146_Out_1_Float);
float _Property_b67a6773dce34e91ae69bbf282d871cc_Out_0_Float = _F0;
float _Property_703d9ec0a0894a3b965f0ed25a10435b_Out_0_Float = _F0;
float _Add_8ad10875906b4a80872f2b2fb0518183_Out_2_Float;
Unity_Add_float(_Property_4678b902494b4e1a9b08a8067b7bed85_Out_0_Float, _Property_703d9ec0a0894a3b965f0ed25a10435b_Out_0_Float, _Add_8ad10875906b4a80872f2b2fb0518183_Out_2_Float);
float3 _Property_b5d757941bc04f70897cc735055cef09_Out_0_Vector3 = _NormalWS;
bool _Property_b5d757941bc04f70897cc735055cef09_Out_0_Vector3_IsConnected = _NormalWS_3240674a787044a092398b1ca753ad83_IsConnected;
float3 _BranchOnInputConnection_43b8bde55a8a41468ba21d53db128986_Out_3_Vector3 = _Property_b5d757941bc04f70897cc735055cef09_Out_0_Vector3_IsConnected ? _Property_b5d757941bc04f70897cc735055cef09_Out_0_Vector3 : IN.WorldSpaceNormal;
float _FresnelEffect_34b729c62edd4d5f99dc20e2e7d0a7fa_Out_3_Float;
Unity_FresnelEffect_float(_BranchOnInputConnection_43b8bde55a8a41468ba21d53db128986_Out_3_Vector3, IN.WorldSpaceViewDirection, float(4), _FresnelEffect_34b729c62edd4d5f99dc20e2e7d0a7fa_Out_3_Float);
float _Lerp_1cad776e609842c181b8acfaef47c317_Out_3_Float;
Unity_Lerp_float(_Property_b67a6773dce34e91ae69bbf282d871cc_Out_0_Float, _Add_8ad10875906b4a80872f2b2fb0518183_Out_2_Float, _FresnelEffect_34b729c62edd4d5f99dc20e2e7d0a7fa_Out_3_Float, _Lerp_1cad776e609842c181b8acfaef47c317_Out_3_Float);
float _Multiply_0d364d1c231246d981281b868ea74a95_Out_2_Float;
Unity_Multiply_float_float(_Reciprocal_67b338305d0043abb9e7d82dd0f16146_Out_1_Float, _Lerp_1cad776e609842c181b8acfaef47c317_Out_3_Float, _Multiply_0d364d1c231246d981281b868ea74a95_Out_2_Float);
float3 _Property_87ae51a595c24e46ad9ef0f4493231fc_Out_0_Vector3 = _Base_Color;
float _Property_ce0a90815c5046b48dd0564711f2b466_Out_0_Float = _Metallic;
float3 _Lerp_6b4c86a1d5004851a7dba1bacc4fd953_Out_3_Vector3;
Unity_Lerp_float3((_Multiply_0d364d1c231246d981281b868ea74a95_Out_2_Float.xxx), _Property_87ae51a595c24e46ad9ef0f4493231fc_Out_0_Vector3, (_Property_ce0a90815c5046b48dd0564711f2b466_Out_0_Float.xxx), _Lerp_6b4c86a1d5004851a7dba1bacc4fd953_Out_3_Vector3);
Reflectance_1 = _Lerp_6b4c86a1d5004851a7dba1bacc4fd953_Out_3_Vector3;
}

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

void Unity_Multiply_half3_half3(half3 A, half3 B, out half3 Out)
{
Out = A * B;
}

void Unity_Negate_float3(float3 In, out float3 Out)
{
    Out = -1 * In;
}

void Unity_Reflection_float3(float3 In, float3 Normal, out float3 Out)
{
    Out = reflect(In, Normal);
}

// unity-custom-func-begin
void URPReflectionProbe_float(float3 positionWS, float3 reflectVector, float2 normalizedScreenSpaceUV, float roughness, float occlusion, out float3 reflection){
#ifdef SHADERGRAPH_PREVIEW

    reflection = float3(0,0,0);

#else

    reflection = GlossyEnvironmentReflection(reflectVector, positionWS, roughness, occlusion, normalizedScreenSpaceUV);

#endif
}
// unity-custom-func-end

struct Bindings_SampleReflectionProbes_f70e1da6fb6a720439a85a6a2c814a87_float
{
float3 WorldSpaceNormal;
float3 WorldSpaceViewDirection;
float3 WorldSpacePosition;
float2 NDCPosition;
};

void SG_SampleReflectionProbes_f70e1da6fb6a720439a85a6a2c814a87_float(float3 _positionWS, bool _positionWS_d6701bdc1f184a57ac2283491fc460d9_IsConnected, float3 _reflectVector, bool _reflectVector_3e2eb19b69b8469eaf2302c7abc4cbc5_IsConnected, float _smoothness, float _occlusion, Bindings_SampleReflectionProbes_f70e1da6fb6a720439a85a6a2c814a87_float IN, out float3 Out_1)
{
float3 _Property_b993dfa9c8bb4e4ea4f3cb1768e92822_Out_0_Vector3 = _positionWS;
bool _Property_b993dfa9c8bb4e4ea4f3cb1768e92822_Out_0_Vector3_IsConnected = _positionWS_d6701bdc1f184a57ac2283491fc460d9_IsConnected;
float3 _BranchOnInputConnection_8fb583036b0c4313a1ecd93143939f21_Out_3_Vector3 = _Property_b993dfa9c8bb4e4ea4f3cb1768e92822_Out_0_Vector3_IsConnected ? _Property_b993dfa9c8bb4e4ea4f3cb1768e92822_Out_0_Vector3 : IN.WorldSpacePosition;
float3 _Property_27869743c4c14e898d5c15f6fdd4e044_Out_0_Vector3 = _reflectVector;
bool _Property_27869743c4c14e898d5c15f6fdd4e044_Out_0_Vector3_IsConnected = _reflectVector_3e2eb19b69b8469eaf2302c7abc4cbc5_IsConnected;
float3 _Negate_9cf7cea21c5641239fdbcb32480ac39e_Out_1_Vector3;
Unity_Negate_float3(IN.WorldSpaceViewDirection, _Negate_9cf7cea21c5641239fdbcb32480ac39e_Out_1_Vector3);
float3 _Reflection_c8689c494aab4411aadc74299549c6cb_Out_2_Vector3;
Unity_Reflection_float3(_Negate_9cf7cea21c5641239fdbcb32480ac39e_Out_1_Vector3, IN.WorldSpaceNormal, _Reflection_c8689c494aab4411aadc74299549c6cb_Out_2_Vector3);
float3 _BranchOnInputConnection_9600230d09794702a61c1a01f8e842a5_Out_3_Vector3 = _Property_27869743c4c14e898d5c15f6fdd4e044_Out_0_Vector3_IsConnected ? _Property_27869743c4c14e898d5c15f6fdd4e044_Out_0_Vector3 : _Reflection_c8689c494aab4411aadc74299549c6cb_Out_2_Vector3;
float4 _ScreenPosition_270e438746a9466e8aaf01f4903f62fb_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
float _Property_9012e47da801473d8ef85a4092281eb2_Out_0_Float = _smoothness;
float _OneMinus_b2508f25afb44017ba3480edc35cf631_Out_1_Float;
Unity_OneMinus_float(_Property_9012e47da801473d8ef85a4092281eb2_Out_0_Float, _OneMinus_b2508f25afb44017ba3480edc35cf631_Out_1_Float);
float _Property_d602b1723845462cbf00324de1e9e82a_Out_0_Float = _occlusion;
float3 _URPReflectionProbeCustomFunction_7233d098cd214f55baf898d486bfdf4b_reflection_4_Vector3;
URPReflectionProbe_float(_BranchOnInputConnection_8fb583036b0c4313a1ecd93143939f21_Out_3_Vector3, _BranchOnInputConnection_9600230d09794702a61c1a01f8e842a5_Out_3_Vector3, (_ScreenPosition_270e438746a9466e8aaf01f4903f62fb_Out_0_Vector4.xy), _OneMinus_b2508f25afb44017ba3480edc35cf631_Out_1_Float, _Property_d602b1723845462cbf00324de1e9e82a_Out_0_Float, _URPReflectionProbeCustomFunction_7233d098cd214f55baf898d486bfdf4b_reflection_4_Vector3);
Out_1 = _URPReflectionProbeCustomFunction_7233d098cd214f55baf898d486bfdf4b_reflection_4_Vector3;
}

void Unity_Add_float3(float3 A, float3 B, out float3 Out)
{
    Out = A + B;
}

// unity-custom-func-begin
void SSAO_float(float2 normalizedScreenSpaceUV, out float indirectAmbientOcclusion, out float directAmbientOcclusion){
#if defined(_SCREEN_SPACE_OCCLUSION) && !defined(_SURFACE_TYPE_TRANSPARENT) && !defined(SHADERGRAPH_PREVIEW)

    float ssao = saturate(SampleAmbientOcclusion(normalizedScreenSpaceUV) + (1.0 - _AmbientOcclusionParam.x));

    indirectAmbientOcclusion = ssao;

    directAmbientOcclusion = lerp(half(1.0), ssao, _AmbientOcclusionParam.w);

#else

    directAmbientOcclusion = half(1.0);

    indirectAmbientOcclusion = half(1.0);

#endif
}
// unity-custom-func-end

struct Bindings_ScreenSpaceAmbientOcclusion_616a08cdf385c2d4997a5ed9d01e16a8_float
{
float2 NDCPosition;
};

void SG_ScreenSpaceAmbientOcclusion_616a08cdf385c2d4997a5ed9d01e16a8_float(Bindings_ScreenSpaceAmbientOcclusion_616a08cdf385c2d4997a5ed9d01e16a8_float IN, out float indirectAO_1, out float directAO_2)
{
float4 _ScreenPosition_0fdc511287e14fd48ca909caba575383_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
float _SSAOCustomFunction_0f48e52099d04b51a6b1dc52cce50d39_indirectAmbientOcclusion_0_Float;
float _SSAOCustomFunction_0f48e52099d04b51a6b1dc52cce50d39_directAmbientOcclusion_1_Float;
SSAO_float((_ScreenPosition_0fdc511287e14fd48ca909caba575383_Out_0_Vector4.xy), _SSAOCustomFunction_0f48e52099d04b51a6b1dc52cce50d39_indirectAmbientOcclusion_0_Float, _SSAOCustomFunction_0f48e52099d04b51a6b1dc52cce50d39_directAmbientOcclusion_1_Float);
indirectAO_1 = _SSAOCustomFunction_0f48e52099d04b51a6b1dc52cce50d39_indirectAmbientOcclusion_0_Float;
directAO_2 = _SSAOCustomFunction_0f48e52099d04b51a6b1dc52cce50d39_directAmbientOcclusion_1_Float;
}

void Unity_Minimum_float(float A, float B, out float Out)
{
    Out = min(A, B);
};

struct Bindings_AmbientURP_300875fdd653fe340b08ad1547984cf1_float
{
float3 WorldSpaceNormal;
float3 WorldSpaceViewDirection;
float3 WorldSpacePosition;
float2 NDCPosition;
float2 PixelPosition;
half4 uv1;
half4 uv2;
};

void SG_AmbientURP_300875fdd653fe340b08ad1547984cf1_float(float3 _Base_Color, float3 _NormalWS, bool _NormalWS_3a565a44841d4b729f8e86b08d09299c_IsConnected, float _Metallic, float _Smoothness, float3 _Reflectance, float _Ambient_Occlusion, Bindings_AmbientURP_300875fdd653fe340b08ad1547984cf1_float IN, out float3 Ambient_1, out float DirectAO_2)
{
float3 _Property_d72d925c86ff4010a968b702f0972f69_Out_0_Vector3 = _NormalWS;
bool _Property_d72d925c86ff4010a968b702f0972f69_Out_0_Vector3_IsConnected = _NormalWS_3a565a44841d4b729f8e86b08d09299c_IsConnected;
float3 _BranchOnInputConnection_5e35c0fc2eee4cf7ae47da45409fa2a7_Out_3_Vector3 = _Property_d72d925c86ff4010a968b702f0972f69_Out_0_Vector3_IsConnected ? _Property_d72d925c86ff4010a968b702f0972f69_Out_0_Vector3 : IN.WorldSpaceNormal;
float3 _BakedGI_1ac35076ff2349f99fec2cef2550ff2d_Out_1_Vector3 = SHADERGRAPH_BAKED_GI(IN.WorldSpacePosition, _BranchOnInputConnection_5e35c0fc2eee4cf7ae47da45409fa2a7_Out_3_Vector3, IN.PixelPosition.xy, IN.uv1.xy, IN.uv2.xy, true);
float3 _Property_5fb17e215f49424cb9cc9d0806f3f47d_Out_0_Vector3 = _Base_Color;
float _Property_f995d8544fdb448d85ac845c7bdee967_Out_0_Float = _Metallic;
float3 _Lerp_842ba4fcd0cf48a3afa108eecd7d56a8_Out_3_Vector3;
Unity_Lerp_float3(_Property_5fb17e215f49424cb9cc9d0806f3f47d_Out_0_Vector3, float3(0, 0, 0), (_Property_f995d8544fdb448d85ac845c7bdee967_Out_0_Float.xxx), _Lerp_842ba4fcd0cf48a3afa108eecd7d56a8_Out_3_Vector3);
float3 _Multiply_48ca9faac6354eefabc65eeb591f3fc4_Out_2_Vector3;
Unity_Multiply_float3_float3(_BakedGI_1ac35076ff2349f99fec2cef2550ff2d_Out_1_Vector3, _Lerp_842ba4fcd0cf48a3afa108eecd7d56a8_Out_3_Vector3, _Multiply_48ca9faac6354eefabc65eeb591f3fc4_Out_2_Vector3);
float3 _Negate_4f98a1dfbc4d4bd1abe58f406453303f_Out_1_Vector3;
Unity_Negate_float3(IN.WorldSpaceViewDirection, _Negate_4f98a1dfbc4d4bd1abe58f406453303f_Out_1_Vector3);
float3 _Reflection_710a69cb22b745929e6bb9b84d11de2f_Out_2_Vector3;
Unity_Reflection_float3(_Negate_4f98a1dfbc4d4bd1abe58f406453303f_Out_1_Vector3, _BranchOnInputConnection_5e35c0fc2eee4cf7ae47da45409fa2a7_Out_3_Vector3, _Reflection_710a69cb22b745929e6bb9b84d11de2f_Out_2_Vector3);
float _Property_8c3e921b9cb34f7b82d2a71254653c09_Out_0_Float = _Smoothness;
Bindings_SampleReflectionProbes_f70e1da6fb6a720439a85a6a2c814a87_float _SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08;
_SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08.WorldSpaceNormal = IN.WorldSpaceNormal;
_SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
_SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08.WorldSpacePosition = IN.WorldSpacePosition;
_SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08.NDCPosition = IN.NDCPosition;
float3 _SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08_Out_1_Vector3;
SG_SampleReflectionProbes_f70e1da6fb6a720439a85a6a2c814a87_float(half3 (0, 0, 0), false, _Reflection_710a69cb22b745929e6bb9b84d11de2f_Out_2_Vector3, true, _Property_8c3e921b9cb34f7b82d2a71254653c09_Out_0_Float, half(1), _SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08, _SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08_Out_1_Vector3);
float3 _Property_2ddaa58bd1e94d0b8508ce91ad39fa39_Out_0_Vector3 = _Reflectance;
float3 _Multiply_40be6c08ca2f44ef99b6a2b81955d62c_Out_2_Vector3;
Unity_Multiply_float3_float3(_SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08_Out_1_Vector3, _Property_2ddaa58bd1e94d0b8508ce91ad39fa39_Out_0_Vector3, _Multiply_40be6c08ca2f44ef99b6a2b81955d62c_Out_2_Vector3);
float3 _Add_c0a57a54eb8b4419a7e907a65e6556a7_Out_2_Vector3;
Unity_Add_float3(_Multiply_48ca9faac6354eefabc65eeb591f3fc4_Out_2_Vector3, _Multiply_40be6c08ca2f44ef99b6a2b81955d62c_Out_2_Vector3, _Add_c0a57a54eb8b4419a7e907a65e6556a7_Out_2_Vector3);
float _Property_5a996c5d941d46019b3ac5ada526c475_Out_0_Float = _Ambient_Occlusion;
Bindings_ScreenSpaceAmbientOcclusion_616a08cdf385c2d4997a5ed9d01e16a8_float _ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e;
_ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e.NDCPosition = IN.NDCPosition;
half _ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e_indirectAO_1_Float;
half _ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e_directAO_2_Float;
SG_ScreenSpaceAmbientOcclusion_616a08cdf385c2d4997a5ed9d01e16a8_float(_ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e, _ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e_indirectAO_1_Float, _ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e_directAO_2_Float);
float _Minimum_699e1643e9974baa97f6f21c8f949d09_Out_2_Float;
Unity_Minimum_float(_Property_5a996c5d941d46019b3ac5ada526c475_Out_0_Float, _ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e_indirectAO_1_Float, _Minimum_699e1643e9974baa97f6f21c8f949d09_Out_2_Float);
float3 _Multiply_ccaf4dfa5cdb4d9fae7fd92dc7d512da_Out_2_Vector3;
Unity_Multiply_float3_float3(_Add_c0a57a54eb8b4419a7e907a65e6556a7_Out_2_Vector3, (_Minimum_699e1643e9974baa97f6f21c8f949d09_Out_2_Float.xxx), _Multiply_ccaf4dfa5cdb4d9fae7fd92dc7d512da_Out_2_Vector3);
float _Minimum_c4dcab6b18b34dde987e68f86d22aed7_Out_2_Float;
Unity_Minimum_float(_Property_5a996c5d941d46019b3ac5ada526c475_Out_0_Float, _ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e_directAO_2_Float, _Minimum_c4dcab6b18b34dde987e68f86d22aed7_Out_2_Float);
Ambient_1 = _Multiply_ccaf4dfa5cdb4d9fae7fd92dc7d512da_Out_2_Vector3;
DirectAO_2 = _Minimum_c4dcab6b18b34dde987e68f86d22aed7_Out_2_Float;
}

// unity-custom-func-begin
void GetMainLightData_float(float3 worldPos, out float3 direction, out float3 color, out float shadowAtten){
#ifdef SHADERGRAPH_PREVIEW
    direction = normalize(float3(-0.7,0.7,-0.7));
    color = float3(1,1,1);
    shadowAtten = 1;
#else
    #if defined(UNIVERSAL_PIPELINE_CORE_INCLUDED)
        float4 shadowCoord = TransformWorldToShadowCoord(worldPos);
        Light mainLight = GetMainLight(shadowCoord);
        direction = mainLight.direction;
        color = mainLight.color;
        shadowAtten = mainLight.shadowAttenuation;
    #else
        direction = normalize(float3(-0.7, 0.7, -0.7));
        color = float3(1, 1, 1);
        shadowAtten = 0;
    #endif
#endif
}
// unity-custom-func-end

// unity-custom-func-begin
void GetMainLightData_half(half3 worldPos, out half3 direction, out half3 color, out half shadowAtten){
#ifdef SHADERGRAPH_PREVIEW
    direction = normalize(float3(-0.7,0.7,-0.7));
    color = float3(1,1,1);
    shadowAtten = 1;
#else
    #if defined(UNIVERSAL_PIPELINE_CORE_INCLUDED)
        float4 shadowCoord = TransformWorldToShadowCoord(worldPos);
        Light mainLight = GetMainLight(shadowCoord);
        direction = mainLight.direction;
        color = mainLight.color;
        shadowAtten = mainLight.shadowAttenuation;
    #else
        direction = normalize(float3(-0.7, 0.7, -0.7));
        color = float3(1, 1, 1);
        shadowAtten = 0;
    #endif
#endif
}
// unity-custom-func-end

struct Bindings_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float
{
float3 AbsoluteWorldSpacePosition;
};

void SG_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float(Bindings_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float IN, out float3 Direction_1, out float3 Color_2, out float ShadowAtten_3)
{
float3 _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_direction_2_Vector3;
float3 _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_color_3_Vector3;
float _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_shadowAtten_5_Float;
GetMainLightData_float(IN.AbsoluteWorldSpacePosition, _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_direction_2_Vector3, _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_color_3_Vector3, _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_shadowAtten_5_Float);
Direction_1 = _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_direction_2_Vector3;
Color_2 = _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_color_3_Vector3;
ShadowAtten_3 = _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_shadowAtten_5_Float;
}

struct Bindings_MainLight_f97aba6a33b86e5498cdd202ba0c9313_half
{
float3 AbsoluteWorldSpacePosition;
};

void SG_MainLight_f97aba6a33b86e5498cdd202ba0c9313_half(Bindings_MainLight_f97aba6a33b86e5498cdd202ba0c9313_half IN, out half3 Direction_1, out half3 Color_2, out half ShadowAtten_3)
{
half3 _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_direction_2_Vector3;
half3 _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_color_3_Vector3;
half _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_shadowAtten_5_Float;
GetMainLightData_half(IN.AbsoluteWorldSpacePosition, _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_direction_2_Vector3, _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_color_3_Vector3, _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_shadowAtten_5_Float);
Direction_1 = _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_direction_2_Vector3;
Color_2 = _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_color_3_Vector3;
ShadowAtten_3 = _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_shadowAtten_5_Float;
}

void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
{
    Out = dot(A, B);
}

void Unity_DotProduct_half3(half3 A, half3 B, out half Out)
{
    Out = dot(A, B);
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Saturate_half(half In, out half Out)
{
    Out = saturate(In);
}

struct Bindings_DiffuseLambert_cb5cb9cef826e9f448011787f0d627b2_half
{
float3 WorldSpaceNormal;
float3 AbsoluteWorldSpacePosition;
};

void SG_DiffuseLambert_cb5cb9cef826e9f448011787f0d627b2_half(half3 _NormalWS, bool _NormalWS_68a7999ae9ea4bfba3702fd95b0d1a14_IsConnected, half3 _LightVector, bool _LightVector_a12354c78b694cc6b2bdddd67d09ccdc_IsConnected, Bindings_DiffuseLambert_cb5cb9cef826e9f448011787f0d627b2_half IN, out half Diffuse_1)
{
half3 _Property_c979bfc9e06b459ca5e503658f2eda27_Out_0_Vector3 = _NormalWS;
bool _Property_c979bfc9e06b459ca5e503658f2eda27_Out_0_Vector3_IsConnected = _NormalWS_68a7999ae9ea4bfba3702fd95b0d1a14_IsConnected;
half3 _BranchOnInputConnection_71cde5ac4ee04aacb1e2544c8017ba47_Out_3_Vector3 = _Property_c979bfc9e06b459ca5e503658f2eda27_Out_0_Vector3_IsConnected ? _Property_c979bfc9e06b459ca5e503658f2eda27_Out_0_Vector3 : IN.WorldSpaceNormal;
half3 _Property_99ccf4aecf59420794efa0951355f7ab_Out_0_Vector3 = _LightVector;
bool _Property_99ccf4aecf59420794efa0951355f7ab_Out_0_Vector3_IsConnected = _LightVector_a12354c78b694cc6b2bdddd67d09ccdc_IsConnected;
Bindings_MainLight_f97aba6a33b86e5498cdd202ba0c9313_half _MainLight_fa0151c045984bcab58e58725bae0709;
_MainLight_fa0151c045984bcab58e58725bae0709.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
half3 _MainLight_fa0151c045984bcab58e58725bae0709_Direction_1_Vector3;
half3 _MainLight_fa0151c045984bcab58e58725bae0709_Color_2_Vector3;
half _MainLight_fa0151c045984bcab58e58725bae0709_ShadowAtten_3_Float;
SG_MainLight_f97aba6a33b86e5498cdd202ba0c9313_half(_MainLight_fa0151c045984bcab58e58725bae0709, _MainLight_fa0151c045984bcab58e58725bae0709_Direction_1_Vector3, _MainLight_fa0151c045984bcab58e58725bae0709_Color_2_Vector3, _MainLight_fa0151c045984bcab58e58725bae0709_ShadowAtten_3_Float);
half3 _BranchOnInputConnection_d18845e766084954af1aa554531c90b9_Out_3_Vector3 = _Property_99ccf4aecf59420794efa0951355f7ab_Out_0_Vector3_IsConnected ? _Property_99ccf4aecf59420794efa0951355f7ab_Out_0_Vector3 : _MainLight_fa0151c045984bcab58e58725bae0709_Direction_1_Vector3;
half _DotProduct_daa979e4f9384944a14a23e079be6a5c_Out_2_Float;
Unity_DotProduct_half3(_BranchOnInputConnection_71cde5ac4ee04aacb1e2544c8017ba47_Out_3_Vector3, _BranchOnInputConnection_d18845e766084954af1aa554531c90b9_Out_3_Vector3, _DotProduct_daa979e4f9384944a14a23e079be6a5c_Out_2_Float);
half _Saturate_4747439b9bfa431293a93646ce71aa12_Out_1_Float;
Unity_Saturate_half(_DotProduct_daa979e4f9384944a14a23e079be6a5c_Out_2_Float, _Saturate_4747439b9bfa431293a93646ce71aa12_Out_1_Float);
Diffuse_1 = _Saturate_4747439b9bfa431293a93646ce71aa12_Out_1_Float;
}

void Unity_Clamp_float(float In, float Min, float Max, out float Out)
{
    Out = clamp(In, Min, Max);
}

void Unity_Normalize_float3(float3 In, out float3 Out)
{
    Out = normalize(In);
}

struct Bindings_HalfAngle_e6f25cf5cc5b2cc4da597068c1610d98_float
{
};

void SG_HalfAngle_e6f25cf5cc5b2cc4da597068c1610d98_float(float3 _viewDir, float3 _lightDir, Bindings_HalfAngle_e6f25cf5cc5b2cc4da597068c1610d98_float IN, out float3 Out_1)
{
float3 _Property_fde52ad74bda46adabbcc34b42b16131_Out_0_Vector3 = _viewDir;
float3 _Property_1dc55a6640574aaf8c04290eb0d5e816_Out_0_Vector3 = _lightDir;
float3 _Add_2a8cf5c52e8c4e3fb8c3f9a87b68b2a2_Out_2_Vector3;
Unity_Add_float3(_Property_fde52ad74bda46adabbcc34b42b16131_Out_0_Vector3, _Property_1dc55a6640574aaf8c04290eb0d5e816_Out_0_Vector3, _Add_2a8cf5c52e8c4e3fb8c3f9a87b68b2a2_Out_2_Vector3);
float3 _Normalize_b3b8196f46224ae3a998bba24956de7f_Out_1_Vector3;
Unity_Normalize_float3(_Add_2a8cf5c52e8c4e3fb8c3f9a87b68b2a2_Out_2_Vector3, _Normalize_b3b8196f46224ae3a998bba24956de7f_Out_1_Vector3);
Out_1 = _Normalize_b3b8196f46224ae3a998bba24956de7f_Out_1_Vector3;
}

void Unity_Subtract_float(float A, float B, out float Out)
{
    Out = A - B;
}

void Unity_Subtract_half(half A, half B, out half Out)
{
    Out = A - B;
}

void Unity_Maximum_float(float A, float B, out float Out)
{
    Out = max(A, B);
}

void Unity_Maximum_half(half A, half B, out half Out)
{
    Out = max(A, B);
}

// unity-custom-func-begin
void ClampHalf_half(half In, out half Out){
// On platforms where half actually means something, the denominator has a risk of overflow
// clamp below was added specifically to "fix" that, but dx compiler (we convert bytecode to metal/gles)
// sees that specularTerm have only non-negative terms, so it skips max(0,..) in clamp (leaving only min(100,...))

Out = In;
#if REAL_IS_HALF
	Out = Out - HALF_MIN;
	Out = clamp(Out, 0.0, 1000.0);// Prevent FP16 overflow on mobiles
#endif
}
// unity-custom-func-end

struct Bindings_SpecularURP_836ccbead8eba604dae19317e6fd4f6f_half
{
float3 WorldSpaceNormal;
float3 WorldSpaceViewDirection;
float3 AbsoluteWorldSpacePosition;
};

void SG_SpecularURP_836ccbead8eba604dae19317e6fd4f6f_half(float3 _NormalWS, bool _NormalWS_5a3c9a3a7faa491894a42d170b5bfeb5_IsConnected, half _Smoothness, half3 _Reflectance, float3 _LightVector, bool _LightVector_3db37b6247094f32bcccc4cb689d525f_IsConnected, Bindings_SpecularURP_836ccbead8eba604dae19317e6fd4f6f_half IN, out half3 Specular_1)
{
half _Property_65663a4adb9d4d15a53c703bd776ed76_Out_0_Float = _Smoothness;
half _OneMinus_6b5b83d6bb3448b4a48ff714eae900b8_Out_1_Float;
Unity_OneMinus_half(_Property_65663a4adb9d4d15a53c703bd776ed76_Out_0_Float, _OneMinus_6b5b83d6bb3448b4a48ff714eae900b8_Out_1_Float);
half _Multiply_0d498c303fa747ca821fcfd6d09f0cac_Out_2_Float;
Unity_Multiply_half_half(_OneMinus_6b5b83d6bb3448b4a48ff714eae900b8_Out_1_Float, _OneMinus_6b5b83d6bb3448b4a48ff714eae900b8_Out_1_Float, _Multiply_0d498c303fa747ca821fcfd6d09f0cac_Out_2_Float);
half _Multiply_58dcb1541dc645ee91419691340a6e24_Out_2_Float;
Unity_Multiply_half_half(_Multiply_0d498c303fa747ca821fcfd6d09f0cac_Out_2_Float, _Multiply_0d498c303fa747ca821fcfd6d09f0cac_Out_2_Float, _Multiply_58dcb1541dc645ee91419691340a6e24_Out_2_Float);
float3 _Property_031663d8c32f41ec8c5aa64dfd664823_Out_0_Vector3 = _LightVector;
bool _Property_031663d8c32f41ec8c5aa64dfd664823_Out_0_Vector3_IsConnected = _LightVector_3db37b6247094f32bcccc4cb689d525f_IsConnected;
Bindings_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float _MainLight_6570bf88718b46ebb6bd80eec408287a;
_MainLight_6570bf88718b46ebb6bd80eec408287a.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
float3 _MainLight_6570bf88718b46ebb6bd80eec408287a_Direction_1_Vector3;
float3 _MainLight_6570bf88718b46ebb6bd80eec408287a_Color_2_Vector3;
float _MainLight_6570bf88718b46ebb6bd80eec408287a_ShadowAtten_3_Float;
SG_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float(_MainLight_6570bf88718b46ebb6bd80eec408287a, _MainLight_6570bf88718b46ebb6bd80eec408287a_Direction_1_Vector3, _MainLight_6570bf88718b46ebb6bd80eec408287a_Color_2_Vector3, _MainLight_6570bf88718b46ebb6bd80eec408287a_ShadowAtten_3_Float);
float3 _BranchOnInputConnection_6a7b13b3cb82474aa187229c3d17a00f_Out_3_Vector3 = _Property_031663d8c32f41ec8c5aa64dfd664823_Out_0_Vector3_IsConnected ? _Property_031663d8c32f41ec8c5aa64dfd664823_Out_0_Vector3 : _MainLight_6570bf88718b46ebb6bd80eec408287a_Direction_1_Vector3;
Bindings_HalfAngle_e6f25cf5cc5b2cc4da597068c1610d98_float _HalfAngle_f48886360d2649d8b7540e6fb3eef669;
float3 _HalfAngle_f48886360d2649d8b7540e6fb3eef669_Out_1_Vector3;
SG_HalfAngle_e6f25cf5cc5b2cc4da597068c1610d98_float(IN.WorldSpaceViewDirection, _BranchOnInputConnection_6a7b13b3cb82474aa187229c3d17a00f_Out_3_Vector3, _HalfAngle_f48886360d2649d8b7540e6fb3eef669, _HalfAngle_f48886360d2649d8b7540e6fb3eef669_Out_1_Vector3);
float3 _Property_801dfbee5fa540ac80af739a98535520_Out_0_Vector3 = _NormalWS;
bool _Property_801dfbee5fa540ac80af739a98535520_Out_0_Vector3_IsConnected = _NormalWS_5a3c9a3a7faa491894a42d170b5bfeb5_IsConnected;
float3 _BranchOnInputConnection_72430741d0e04d2dbf5368b624a090cc_Out_3_Vector3 = _Property_801dfbee5fa540ac80af739a98535520_Out_0_Vector3_IsConnected ? _Property_801dfbee5fa540ac80af739a98535520_Out_0_Vector3 : IN.WorldSpaceNormal;
float _DotProduct_4558c6edcb084d359ac8ee4b2934ea05_Out_2_Float;
Unity_DotProduct_float3(_HalfAngle_f48886360d2649d8b7540e6fb3eef669_Out_1_Vector3, _BranchOnInputConnection_72430741d0e04d2dbf5368b624a090cc_Out_3_Vector3, _DotProduct_4558c6edcb084d359ac8ee4b2934ea05_Out_2_Float);
float _Saturate_23d3962f416c4150a990dcb36b5ecbc4_Out_1_Float;
Unity_Saturate_float(_DotProduct_4558c6edcb084d359ac8ee4b2934ea05_Out_2_Float, _Saturate_23d3962f416c4150a990dcb36b5ecbc4_Out_1_Float);
float _Multiply_0c95bad7699b4ca9a8ce1e6744a02f14_Out_2_Float;
Unity_Multiply_float_float(_Saturate_23d3962f416c4150a990dcb36b5ecbc4_Out_1_Float, _Saturate_23d3962f416c4150a990dcb36b5ecbc4_Out_1_Float, _Multiply_0c95bad7699b4ca9a8ce1e6744a02f14_Out_2_Float);
half _Subtract_c6521ef2abfd4cb6b19d856f80ce6635_Out_2_Float;
Unity_Subtract_half(_Multiply_58dcb1541dc645ee91419691340a6e24_Out_2_Float, half(1), _Subtract_c6521ef2abfd4cb6b19d856f80ce6635_Out_2_Float);
float _Multiply_428fcfebb99e43a2846be57068218dd1_Out_2_Float;
Unity_Multiply_float_float(_Multiply_0c95bad7699b4ca9a8ce1e6744a02f14_Out_2_Float, _Subtract_c6521ef2abfd4cb6b19d856f80ce6635_Out_2_Float, _Multiply_428fcfebb99e43a2846be57068218dd1_Out_2_Float);
float _Add_0670771ec2f54d57ab3ba72f8cf8563e_Out_2_Float;
Unity_Add_float(_Multiply_428fcfebb99e43a2846be57068218dd1_Out_2_Float, float(1.00001), _Add_0670771ec2f54d57ab3ba72f8cf8563e_Out_2_Float);
half _Multiply_6de38edabacc4727a961face8b45eec7_Out_2_Float;
Unity_Multiply_half_half(_Add_0670771ec2f54d57ab3ba72f8cf8563e_Out_2_Float, _Add_0670771ec2f54d57ab3ba72f8cf8563e_Out_2_Float, _Multiply_6de38edabacc4727a961face8b45eec7_Out_2_Float);
half _DotProduct_f2e2c0a55fa749c6bcac3befdaf5cc9e_Out_2_Float;
Unity_DotProduct_half3(_HalfAngle_f48886360d2649d8b7540e6fb3eef669_Out_1_Vector3, _MainLight_6570bf88718b46ebb6bd80eec408287a_Direction_1_Vector3, _DotProduct_f2e2c0a55fa749c6bcac3befdaf5cc9e_Out_2_Float);
half _Saturate_b1a77817dddf4a70af2dbe91af25aa03_Out_1_Float;
Unity_Saturate_half(_DotProduct_f2e2c0a55fa749c6bcac3befdaf5cc9e_Out_2_Float, _Saturate_b1a77817dddf4a70af2dbe91af25aa03_Out_1_Float);
half _Multiply_d16da90e46294009bbf058077207a283_Out_2_Float;
Unity_Multiply_half_half(_Saturate_b1a77817dddf4a70af2dbe91af25aa03_Out_1_Float, _Saturate_b1a77817dddf4a70af2dbe91af25aa03_Out_1_Float, _Multiply_d16da90e46294009bbf058077207a283_Out_2_Float);
half _Maximum_d4132949baac4389abbeb7cf75a9450d_Out_2_Float;
Unity_Maximum_half(half(0.1), _Multiply_d16da90e46294009bbf058077207a283_Out_2_Float, _Maximum_d4132949baac4389abbeb7cf75a9450d_Out_2_Float);
half _Multiply_fd05dbe22b3b449c83455ee11e655ceb_Out_2_Float;
Unity_Multiply_half_half(_Multiply_6de38edabacc4727a961face8b45eec7_Out_2_Float, _Maximum_d4132949baac4389abbeb7cf75a9450d_Out_2_Float, _Multiply_fd05dbe22b3b449c83455ee11e655ceb_Out_2_Float);
half _Multiply_93304cb0ca10459185664116606ab5f3_Out_2_Float;
Unity_Multiply_half_half(_Multiply_0d498c303fa747ca821fcfd6d09f0cac_Out_2_Float, 4, _Multiply_93304cb0ca10459185664116606ab5f3_Out_2_Float);
half _Add_f5a8f83262b84718853bbbadf886aa8d_Out_2_Float;
Unity_Add_half(_Multiply_93304cb0ca10459185664116606ab5f3_Out_2_Float, half(2), _Add_f5a8f83262b84718853bbbadf886aa8d_Out_2_Float);
half _Multiply_ceffc5e723e346189be38ea16239f587_Out_2_Float;
Unity_Multiply_half_half(_Multiply_fd05dbe22b3b449c83455ee11e655ceb_Out_2_Float, _Add_f5a8f83262b84718853bbbadf886aa8d_Out_2_Float, _Multiply_ceffc5e723e346189be38ea16239f587_Out_2_Float);
half _Divide_2589d64ba94841aa933a4e5af66460cf_Out_2_Float;
Unity_Divide_half(_Multiply_58dcb1541dc645ee91419691340a6e24_Out_2_Float, _Multiply_ceffc5e723e346189be38ea16239f587_Out_2_Float, _Divide_2589d64ba94841aa933a4e5af66460cf_Out_2_Float);
half _ClampHalfCustomFunction_ff6472ae9f514325a4b9e1f9a0f7a70f_Out_1_Float;
ClampHalf_half(_Divide_2589d64ba94841aa933a4e5af66460cf_Out_2_Float, _ClampHalfCustomFunction_ff6472ae9f514325a4b9e1f9a0f7a70f_Out_1_Float);
half3 _Property_a62a42c671e64b02b9f980de350ccbd3_Out_0_Vector3 = _Reflectance;
half3 _Multiply_db0b4127db554affba0f41edae5085ce_Out_2_Vector3;
Unity_Multiply_half3_half3((_ClampHalfCustomFunction_ff6472ae9f514325a4b9e1f9a0f7a70f_Out_1_Float.xxx), _Property_a62a42c671e64b02b9f980de350ccbd3_Out_0_Vector3, _Multiply_db0b4127db554affba0f41edae5085ce_Out_2_Vector3);
Specular_1 = _Multiply_db0b4127db554affba0f41edae5085ce_Out_2_Vector3;
}

// unity-custom-func-begin
void AddAdditionalLights_float(float Smoothness, float3 WorldPosition, float3 WorldNormal, float3 WorldView, float MainDiffuse, float3 MainSpecular, float3 MainColor, float3 Reflectance, float2 ScreenPosition, out float Diffuse, out float3 Specular, out float3 Color){
Diffuse = MainDiffuse;

Specular = MainSpecular;

Color = MainColor * (MainDiffuse + MainSpecular);



#ifndef SHADERGRAPH_PREVIEW

    

    uint pixelLightCount = GetAdditionalLightsCount();

    half Roughness = pow(1 - Smoothness, 2);

    half Roughness2 = Roughness * Roughness;

	half Roughness2Minus1 = Roughness2 - 1;

	half normalizationTerm = (Roughness * half(4.0) + half(2.0));



#if USE_CLUSTER_LIGHT_LOOP

    // for Foward+ LIGHT_LOOP_BEGIN macro uses inputData.normalizedScreenSpaceUV and inputData.positionWS

    InputData inputData = (InputData)0;



    inputData.normalizedScreenSpaceUV = ScreenPosition;

    inputData.positionWS = WorldPosition;

#endif



    LIGHT_LOOP_BEGIN(pixelLightCount)

		// Call the URP additional light algorithm. This will not calculate shadows, since we don't pass a shadow mask value

		Light light = GetAdditionalLight(lightIndex, WorldPosition);

		// Manually set the shadow attenuation by calculating realtime shadows

		light.shadowAttenuation = AdditionalLightRealtimeShadow(lightIndex, WorldPosition, light.direction);

        #if defined(_LIGHT_COOKIES)

            float3 cookieColor = SampleAdditionalLightCookie(lightIndex, WorldPosition);

            light.color *= cookieColor;

        #endif

        float NdotL = saturate(dot(WorldNormal, light.direction));

        float atten = light.distanceAttenuation * light.shadowAttenuation;

        float thisDiffuse = NdotL * atten;

        //DirectBRDFSpecular



        float3 lightDirectionWSFloat3 = float3(light.direction);

        float3 halfDir = SafeNormalize(lightDirectionWSFloat3 + float3(WorldView));

        float NoH = saturate(dot(float3(WorldNormal), halfDir));

        half LoH = half(saturate(dot(lightDirectionWSFloat3, halfDir)));

        float d = NoH * NoH * Roughness2Minus1 + 1.00001f;

        half LoH2 = LoH * LoH;

        half spec = Roughness2 / ((d * d) * max(0.1h, LoH2) * normalizationTerm);

        #if REAL_IS_HALF

            spec = spec - HALF_MIN;

            spec = clamp(spec, 0.0, 1000.0);

        #endif		

        float3 thisSpecular = spec * Reflectance * NdotL * atten;



        Diffuse += thisDiffuse;

        Specular += thisSpecular;



        Color += light.color * (thisDiffuse + thisSpecular);

    LIGHT_LOOP_END

    float total = Diffuse + dot(Specular, float3(0.333, 0.333, 0.333));

    Color = total <= 0 ? MainColor : Color / total;

#endif
}
// unity-custom-func-end

struct Bindings_AdditionalLightsURP_97b36dcc0c1df064bab3b4b47d231089_float
{
float3 WorldSpaceNormal;
float3 WorldSpaceViewDirection;
float3 AbsoluteWorldSpacePosition;
float2 NDCPosition;
};

void SG_AdditionalLightsURP_97b36dcc0c1df064bab3b4b47d231089_float(float _MainLightDiffuse, float3 _MainLightSpecular, float3 _MainLightColor, float3 _NormalWS, bool _NormalWS_70cbf5ac6da04bf6bd87eb71ccb7c48d_IsConnected, float _Smoothness, float3 _Reflectance, Bindings_AdditionalLightsURP_97b36dcc0c1df064bab3b4b47d231089_float IN, out float Diffuse_1, out float3 Specular_2, out float3 Color_3)
{
float _Property_b9f05025da4f4857a7b1b6f56259a629_Out_0_Float = _Smoothness;
float3 _Property_3e48999a139848e6ab2e955c61810b83_Out_0_Vector3 = _NormalWS;
bool _Property_3e48999a139848e6ab2e955c61810b83_Out_0_Vector3_IsConnected = _NormalWS_70cbf5ac6da04bf6bd87eb71ccb7c48d_IsConnected;
float3 _BranchOnInputConnection_d869e3d8654b48a491de945ad8af6301_Out_3_Vector3 = _Property_3e48999a139848e6ab2e955c61810b83_Out_0_Vector3_IsConnected ? _Property_3e48999a139848e6ab2e955c61810b83_Out_0_Vector3 : IN.WorldSpaceNormal;
float _Property_25880f0697234954b8dc6ef11af3752d_Out_0_Float = _MainLightDiffuse;
float3 _Property_1e29ad89226c4d84a936fe7530839aef_Out_0_Vector3 = _MainLightSpecular;
float3 _Property_ac790fc8215b4b3d8851855d2153960d_Out_0_Vector3 = _MainLightColor;
float3 _Property_eea8eda455d44ae7b30c65f80baac806_Out_0_Vector3 = _Reflectance;
float4 _ScreenPosition_c15512235d2f46b4b03bc2c4a1be229d_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
float _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Diffuse_7_Float;
float3 _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Specular_8_Vector3;
float3 _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Color_9_Vector3;
AddAdditionalLights_float(_Property_b9f05025da4f4857a7b1b6f56259a629_Out_0_Float, IN.AbsoluteWorldSpacePosition, _BranchOnInputConnection_d869e3d8654b48a491de945ad8af6301_Out_3_Vector3, IN.WorldSpaceViewDirection, _Property_25880f0697234954b8dc6ef11af3752d_Out_0_Float, _Property_1e29ad89226c4d84a936fe7530839aef_Out_0_Vector3, _Property_ac790fc8215b4b3d8851855d2153960d_Out_0_Vector3, _Property_eea8eda455d44ae7b30c65f80baac806_Out_0_Vector3, (_ScreenPosition_c15512235d2f46b4b03bc2c4a1be229d_Out_0_Vector4.xy), _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Diffuse_7_Float, _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Specular_8_Vector3, _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Color_9_Vector3);
Diffuse_1 = _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Diffuse_7_Float;
Specular_2 = _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Specular_8_Vector3;
Color_3 = _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Color_9_Vector3;
}

void Unity_Fog_float(out float4 Color, out float Density, float3 Position)
{
    SHADERGRAPH_FOG(Position, Color, Density);
}

struct Bindings_Fog_286ae83400099a24bba6faf005588be7_float
{
float3 ObjectSpacePosition;
};

void SG_Fog_286ae83400099a24bba6faf005588be7_float(float3 _In, Bindings_Fog_286ae83400099a24bba6faf005588be7_float IN, out float3 Out_1)
{
float3 _Property_626923dc627443639da97776de7dcc22_Out_0_Vector3 = _In;
float4 _Fog_acabe3c84c9549f3880ce7d106150576_Color_0_Vector4;
float _Fog_acabe3c84c9549f3880ce7d106150576_Density_1_Float;
Unity_Fog_float(_Fog_acabe3c84c9549f3880ce7d106150576_Color_0_Vector4, _Fog_acabe3c84c9549f3880ce7d106150576_Density_1_Float, IN.ObjectSpacePosition);
float3 _Lerp_9cfca9aa08c7423bab62b39a01237d64_Out_3_Vector3;
Unity_Lerp_float3(_Property_626923dc627443639da97776de7dcc22_Out_0_Vector3, (_Fog_acabe3c84c9549f3880ce7d106150576_Color_0_Vector4.xyz), (_Fog_acabe3c84c9549f3880ce7d106150576_Density_1_Float.xxx), _Lerp_9cfca9aa08c7423bab62b39a01237d64_Out_3_Vector3);
Out_1 = _Lerp_9cfca9aa08c7423bab62b39a01237d64_Out_3_Vector3;
}

struct Bindings_LightURP_17836dba1a675e246923104447b19cbd_float
{
float3 WorldSpaceNormal;
float3 WorldSpaceTangent;
float3 WorldSpaceBiTangent;
float3 WorldSpaceViewDirection;
float3 ObjectSpacePosition;
float3 WorldSpacePosition;
float3 AbsoluteWorldSpacePosition;
float2 NDCPosition;
float2 PixelPosition;
half4 uv1;
half4 uv2;
};

void SG_LightURP_17836dba1a675e246923104447b19cbd_float(float3 _Base_Color, float3 _Normal, bool _Normal_e1611e545480449d80aa5a0e7c2b63c4_IsConnected, float _Metallic, float _Smoothness, float _Ambient_Occlusion, float _Micro_Occlusion, Bindings_LightURP_17836dba1a675e246923104447b19cbd_float IN, out float3 Lit_1)
{
float3 _Property_6ed4205d0e494d9fbe20d17c4850dd01_Out_0_Vector3 = _Base_Color;
float3 _Property_625b0af59fbf4eb3846fcad626b34ca0_Out_0_Vector3 = _Base_Color;
float3 _Property_dbe43d633d7c40db91271fec54a22ee2_Out_0_Vector3 = _Normal;
bool _Property_dbe43d633d7c40db91271fec54a22ee2_Out_0_Vector3_IsConnected = _Normal_e1611e545480449d80aa5a0e7c2b63c4_IsConnected;
float3 _Transform_e8dcf06340124e7d8017300bc4dcb2c9_Out_1_Vector3;
{
float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
_Transform_e8dcf06340124e7d8017300bc4dcb2c9_Out_1_Vector3 = TransformTangentToWorld(_Property_dbe43d633d7c40db91271fec54a22ee2_Out_0_Vector3.xyz, tangentTransform, true);
}
float3 _BranchOnInputConnection_b3c5feecd28b43998390fb43ac1592b1_Out_3_Vector3 = _Property_dbe43d633d7c40db91271fec54a22ee2_Out_0_Vector3_IsConnected ? _Transform_e8dcf06340124e7d8017300bc4dcb2c9_Out_1_Vector3 : IN.WorldSpaceNormal;
float _Property_c5baaae739ad42b392a1b796ed36950b_Out_0_Float = _Metallic;
float _Property_ac10139ecedb4301b4595fa5b13c00b8_Out_0_Float = _Smoothness;
float3 _Property_8ab90e0aaf6a448083ce06c935d78437_Out_0_Vector3 = _Base_Color;
float _Property_2218b1e4c2a849809a373d68812e2b9e_Out_0_Float = _Metallic;
float _Property_732cd42e013c4b79b1d2ba9bc0bad8a6_Out_0_Float = _Smoothness;
float _Property_fdd3b516f2aa41159cf35a16e66b941f_Out_0_Float = _Micro_Occlusion;
float _Multiply_27f0b930a5b849e48209ca66e62866fe_Out_2_Float;
Unity_Multiply_float_float(_Property_fdd3b516f2aa41159cf35a16e66b941f_Out_0_Float, 0.5, _Multiply_27f0b930a5b849e48209ca66e62866fe_Out_2_Float);
float _Lerp_abfa5aa3eaeb4132b82e92eea93328aa_Out_3_Float;
Unity_Lerp_float(float(0), float(0.08), _Multiply_27f0b930a5b849e48209ca66e62866fe_Out_2_Float, _Lerp_abfa5aa3eaeb4132b82e92eea93328aa_Out_3_Float);
Bindings_ReflectanceURP_57a8ea7c8f931c941b2bb57aedc451aa_float _ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d;
_ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d.WorldSpaceNormal = IN.WorldSpaceNormal;
_ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
half3 _ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d_Reflectance_1_Vector3;
SG_ReflectanceURP_57a8ea7c8f931c941b2bb57aedc451aa_float(_Property_8ab90e0aaf6a448083ce06c935d78437_Out_0_Vector3, _BranchOnInputConnection_b3c5feecd28b43998390fb43ac1592b1_Out_3_Vector3, true, _Property_2218b1e4c2a849809a373d68812e2b9e_Out_0_Float, _Property_732cd42e013c4b79b1d2ba9bc0bad8a6_Out_0_Float, _Lerp_abfa5aa3eaeb4132b82e92eea93328aa_Out_3_Float, _ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d, _ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d_Reflectance_1_Vector3);
float _Property_0a056a259612407e813453c548affc50_Out_0_Float = _Ambient_Occlusion;
float _Split_065289545529474a93092a5b161c8bd9_R_1_Float = _Property_dbe43d633d7c40db91271fec54a22ee2_Out_0_Vector3[0];
float _Split_065289545529474a93092a5b161c8bd9_G_2_Float = _Property_dbe43d633d7c40db91271fec54a22ee2_Out_0_Vector3[1];
float _Split_065289545529474a93092a5b161c8bd9_B_3_Float = _Property_dbe43d633d7c40db91271fec54a22ee2_Out_0_Vector3[2];
float _Split_065289545529474a93092a5b161c8bd9_A_4_Float = 0;
float _FresnelEffect_66e2f70f47b04f11b7e25a61d65634e3_Out_3_Float;
Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, float(1), _FresnelEffect_66e2f70f47b04f11b7e25a61d65634e3_Out_3_Float);
float _Lerp_e6a5bc336b4d4fa48faf4eabd1b187b7_Out_3_Float;
Unity_Lerp_float(_Split_065289545529474a93092a5b161c8bd9_B_3_Float, float(1), _FresnelEffect_66e2f70f47b04f11b7e25a61d65634e3_Out_3_Float, _Lerp_e6a5bc336b4d4fa48faf4eabd1b187b7_Out_3_Float);
float _Multiply_2f54e3d54d4542f989d1875f64f31280_Out_2_Float;
Unity_Multiply_float_float(_Property_0a056a259612407e813453c548affc50_Out_0_Float, _Lerp_e6a5bc336b4d4fa48faf4eabd1b187b7_Out_3_Float, _Multiply_2f54e3d54d4542f989d1875f64f31280_Out_2_Float);
Bindings_AmbientURP_300875fdd653fe340b08ad1547984cf1_float _AmbientURP_46e1712500da4aae848bd5b24a05f29f;
_AmbientURP_46e1712500da4aae848bd5b24a05f29f.WorldSpaceNormal = IN.WorldSpaceNormal;
_AmbientURP_46e1712500da4aae848bd5b24a05f29f.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
_AmbientURP_46e1712500da4aae848bd5b24a05f29f.WorldSpacePosition = IN.WorldSpacePosition;
_AmbientURP_46e1712500da4aae848bd5b24a05f29f.NDCPosition = IN.NDCPosition;
_AmbientURP_46e1712500da4aae848bd5b24a05f29f.PixelPosition = IN.PixelPosition;
_AmbientURP_46e1712500da4aae848bd5b24a05f29f.uv1 = IN.uv1;
_AmbientURP_46e1712500da4aae848bd5b24a05f29f.uv2 = IN.uv2;
half3 _AmbientURP_46e1712500da4aae848bd5b24a05f29f_Ambient_1_Vector3;
half _AmbientURP_46e1712500da4aae848bd5b24a05f29f_DirectAO_2_Float;
SG_AmbientURP_300875fdd653fe340b08ad1547984cf1_float(_Property_625b0af59fbf4eb3846fcad626b34ca0_Out_0_Vector3, _BranchOnInputConnection_b3c5feecd28b43998390fb43ac1592b1_Out_3_Vector3, true, _Property_c5baaae739ad42b392a1b796ed36950b_Out_0_Float, _Property_ac10139ecedb4301b4595fa5b13c00b8_Out_0_Float, _ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d_Reflectance_1_Vector3, _Multiply_2f54e3d54d4542f989d1875f64f31280_Out_2_Float, _AmbientURP_46e1712500da4aae848bd5b24a05f29f, _AmbientURP_46e1712500da4aae848bd5b24a05f29f_Ambient_1_Vector3, _AmbientURP_46e1712500da4aae848bd5b24a05f29f_DirectAO_2_Float);
float3 _Multiply_a9decac7cda34291a6910c4cd9ad2700_Out_2_Vector3;
Unity_Multiply_float3_float3(_Property_6ed4205d0e494d9fbe20d17c4850dd01_Out_0_Vector3, (_AmbientURP_46e1712500da4aae848bd5b24a05f29f_DirectAO_2_Float.xxx), _Multiply_a9decac7cda34291a6910c4cd9ad2700_Out_2_Vector3);
float _Property_27a5774949ff4e6c9d8808560c39bc95_Out_0_Float = _Metallic;
float3 _Lerp_7894dcaa210343cc83783b010da9c85c_Out_3_Vector3;
Unity_Lerp_float3(_Multiply_a9decac7cda34291a6910c4cd9ad2700_Out_2_Vector3, float3(0, 0, 0), (_Property_27a5774949ff4e6c9d8808560c39bc95_Out_0_Float.xxx), _Lerp_7894dcaa210343cc83783b010da9c85c_Out_3_Vector3);
Bindings_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float _MainLight_d918d0814080438585a810ba0b8afeb4;
_MainLight_d918d0814080438585a810ba0b8afeb4.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
half3 _MainLight_d918d0814080438585a810ba0b8afeb4_Direction_1_Vector3;
half3 _MainLight_d918d0814080438585a810ba0b8afeb4_Color_2_Vector3;
half _MainLight_d918d0814080438585a810ba0b8afeb4_ShadowAtten_3_Float;
SG_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float(_MainLight_d918d0814080438585a810ba0b8afeb4, _MainLight_d918d0814080438585a810ba0b8afeb4_Direction_1_Vector3, _MainLight_d918d0814080438585a810ba0b8afeb4_Color_2_Vector3, _MainLight_d918d0814080438585a810ba0b8afeb4_ShadowAtten_3_Float);
Bindings_DiffuseLambert_cb5cb9cef826e9f448011787f0d627b2_half _DiffuseLambert_7f9e988376a2438ebc87097469e065d3;
_DiffuseLambert_7f9e988376a2438ebc87097469e065d3.WorldSpaceNormal = IN.WorldSpaceNormal;
_DiffuseLambert_7f9e988376a2438ebc87097469e065d3.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
half _DiffuseLambert_7f9e988376a2438ebc87097469e065d3_Diffuse_1_Float;
SG_DiffuseLambert_cb5cb9cef826e9f448011787f0d627b2_half(_BranchOnInputConnection_b3c5feecd28b43998390fb43ac1592b1_Out_3_Vector3, true, _MainLight_d918d0814080438585a810ba0b8afeb4_Direction_1_Vector3, true, _DiffuseLambert_7f9e988376a2438ebc87097469e065d3, _DiffuseLambert_7f9e988376a2438ebc87097469e065d3_Diffuse_1_Float);
float _Property_a888856c392c4ddfbc144ff5ed452e65_Out_0_Float = _Smoothness;
float _Clamp_6b8538ec3747440bbd39832354f4c497_Out_3_Float;
Unity_Clamp_float(_Property_a888856c392c4ddfbc144ff5ed452e65_Out_0_Float, float(0), float(0.94), _Clamp_6b8538ec3747440bbd39832354f4c497_Out_3_Float);
Bindings_SpecularURP_836ccbead8eba604dae19317e6fd4f6f_half _SpecularURP_bb88623835294209a6f5bbddb1ba7f22;
_SpecularURP_bb88623835294209a6f5bbddb1ba7f22.WorldSpaceNormal = IN.WorldSpaceNormal;
_SpecularURP_bb88623835294209a6f5bbddb1ba7f22.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
_SpecularURP_bb88623835294209a6f5bbddb1ba7f22.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
half3 _SpecularURP_bb88623835294209a6f5bbddb1ba7f22_Specular_1_Vector3;
SG_SpecularURP_836ccbead8eba604dae19317e6fd4f6f_half(_BranchOnInputConnection_b3c5feecd28b43998390fb43ac1592b1_Out_3_Vector3, true, _Clamp_6b8538ec3747440bbd39832354f4c497_Out_3_Float, _ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d_Reflectance_1_Vector3, _MainLight_d918d0814080438585a810ba0b8afeb4_Direction_1_Vector3, true, _SpecularURP_bb88623835294209a6f5bbddb1ba7f22, _SpecularURP_bb88623835294209a6f5bbddb1ba7f22_Specular_1_Vector3);
half3 _Multiply_610f130d22274970bc454dfea38393cd_Out_2_Vector3;
Unity_Multiply_half3_half3((_DiffuseLambert_7f9e988376a2438ebc87097469e065d3_Diffuse_1_Float.xxx), _SpecularURP_bb88623835294209a6f5bbddb1ba7f22_Specular_1_Vector3, _Multiply_610f130d22274970bc454dfea38393cd_Out_2_Vector3);
Bindings_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float _MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e;
_MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
half3 _MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e_Direction_1_Vector3;
half3 _MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e_Color_2_Vector3;
half _MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e_ShadowAtten_3_Float;
SG_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float(_MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e, _MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e_Direction_1_Vector3, _MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e_Color_2_Vector3, _MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e_ShadowAtten_3_Float);
float3 _Multiply_9545e2014858428792b92c57dd77e45c_Out_2_Vector3;
Unity_Multiply_float3_float3(_MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e_Color_2_Vector3, (_MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e_ShadowAtten_3_Float.xxx), _Multiply_9545e2014858428792b92c57dd77e45c_Out_2_Vector3);
Bindings_AdditionalLightsURP_97b36dcc0c1df064bab3b4b47d231089_float _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd;
_AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd.WorldSpaceNormal = IN.WorldSpaceNormal;
_AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
_AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
_AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd.NDCPosition = IN.NDCPosition;
half _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Diffuse_1_Float;
half3 _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Specular_2_Vector3;
half3 _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Color_3_Vector3;
SG_AdditionalLightsURP_97b36dcc0c1df064bab3b4b47d231089_float(_DiffuseLambert_7f9e988376a2438ebc87097469e065d3_Diffuse_1_Float, _Multiply_610f130d22274970bc454dfea38393cd_Out_2_Vector3, _Multiply_9545e2014858428792b92c57dd77e45c_Out_2_Vector3, _BranchOnInputConnection_b3c5feecd28b43998390fb43ac1592b1_Out_3_Vector3, true, _Clamp_6b8538ec3747440bbd39832354f4c497_Out_3_Float, _ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d_Reflectance_1_Vector3, _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd, _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Diffuse_1_Float, _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Specular_2_Vector3, _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Color_3_Vector3);
float3 _Multiply_765841b19beb4cecb786b3295b6aa8e9_Out_2_Vector3;
Unity_Multiply_float3_float3(_Lerp_7894dcaa210343cc83783b010da9c85c_Out_3_Vector3, (_AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Diffuse_1_Float.xxx), _Multiply_765841b19beb4cecb786b3295b6aa8e9_Out_2_Vector3);
float3 _Multiply_90e8c848b8014b22847c7d7e2db6bcf9_Out_2_Vector3;
Unity_Multiply_float3_float3(_AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Specular_2_Vector3, (_AmbientURP_46e1712500da4aae848bd5b24a05f29f_DirectAO_2_Float.xxx), _Multiply_90e8c848b8014b22847c7d7e2db6bcf9_Out_2_Vector3);
float3 _Add_77980781d2204e1b8d249e5f7058e9fb_Out_2_Vector3;
Unity_Add_float3(_Multiply_765841b19beb4cecb786b3295b6aa8e9_Out_2_Vector3, _Multiply_90e8c848b8014b22847c7d7e2db6bcf9_Out_2_Vector3, _Add_77980781d2204e1b8d249e5f7058e9fb_Out_2_Vector3);
float3 _Multiply_9df1a4a5bf654e97b945b2eccf2fc855_Out_2_Vector3;
Unity_Multiply_float3_float3(_Add_77980781d2204e1b8d249e5f7058e9fb_Out_2_Vector3, _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Color_3_Vector3, _Multiply_9df1a4a5bf654e97b945b2eccf2fc855_Out_2_Vector3);
float3 _Add_ad0b3eccabf24dceb374546c3c332ad7_Out_2_Vector3;
Unity_Add_float3(_Multiply_9df1a4a5bf654e97b945b2eccf2fc855_Out_2_Vector3, _AmbientURP_46e1712500da4aae848bd5b24a05f29f_Ambient_1_Vector3, _Add_ad0b3eccabf24dceb374546c3c332ad7_Out_2_Vector3);
Bindings_Fog_286ae83400099a24bba6faf005588be7_float _Fog_4b5ff09555f14324848244007e17d043;
_Fog_4b5ff09555f14324848244007e17d043.ObjectSpacePosition = IN.ObjectSpacePosition;
half3 _Fog_4b5ff09555f14324848244007e17d043_Out_1_Vector3;
SG_Fog_286ae83400099a24bba6faf005588be7_float(_Add_ad0b3eccabf24dceb374546c3c332ad7_Out_2_Vector3, _Fog_4b5ff09555f14324848244007e17d043, _Fog_4b5ff09555f14324848244007e17d043_Out_1_Vector3);
Lit_1 = _Fog_4b5ff09555f14324848244007e17d043_Out_1_Vector3;
}

// unity-custom-func-begin
void DebugMaterialSwitch_float(float3 None, float3 Albedo, float3 Specular, float3 Alpha, float3 Smoothness, float3 AmbientOcclusion, float3 Emission, float3 NormalWS, float3 NormalTS, float3 LightComplexity, float3 Metallic, float3 SpriteMask, float3 RenderingLayerMasks, out float3 Out){
Out = None;
#if !defined(SHADERGRAPH_PREVIEW) && defined(DEBUG_DISPLAY)
[branch] switch(int(_DebugMaterialMode))

{

    case 0:

        Out = None; break;

    case 1:

        Out = Albedo; break;

    case 2:

        Out = Specular; break;
    case 3:

        Out = Alpha; break;
    case 4:

        Out = Smoothness; break;
    case 5:

        Out = AmbientOcclusion;  break;
    case 6:

        Out = Emission;  break;
    case 7:

        Out = NormalWS * 0.5 + 0.5;  break;
    case 8:

        Out = NormalTS * 0.5 + 0.5;  break;
    case 9:

        Out = LightComplexity;  break;
    case 10:

        Out = Metallic;  break;
    case 11:

        Out = SpriteMask;  break;
    case 12:

        Out = RenderingLayerMasks;  break;

    default:

        Out = None; break;

}
#endif

// Disable this define to prevent the global unlit
// fragment pass to override the color output again.
#undef DEBUG_DISPLAY
}
// unity-custom-func-end

struct Bindings_DebugMaterials_53d20e1f36b55014f99f9ccae649c798_float
{
float3 WorldSpaceNormal;
float3 WorldSpaceTangent;
float3 WorldSpaceBiTangent;
float3 WorldSpacePosition;
float2 NDCPosition;
};

void SG_DebugMaterials_53d20e1f36b55014f99f9ccae649c798_float(float3 _In, float3 _Base_Color, float3 _Normal, float _Metallic, float _Smoothness, float3 _Emission, float _Ambient_Occlusion, float _Alpha, Bindings_DebugMaterials_53d20e1f36b55014f99f9ccae649c798_float IN, out float3 Out_1)
{
float3 _Property_dd011cc96ae64d1181317986b1fa1742_Out_0_Vector3 = _In;
float3 _Property_5653941ce5a641f18f7ce7012652025d_Out_0_Vector3 = _Base_Color;
float _Property_45f5c13ff5544581bd61c2442cecd0a1_Out_0_Float = _Alpha;
float _Property_b6c8b448c5324bd3bc59540f628e43a3_Out_0_Float = _Smoothness;
Bindings_ScreenSpaceAmbientOcclusion_616a08cdf385c2d4997a5ed9d01e16a8_float _ScreenSpaceAmbientOcclusion_40f694c4c3ca4e89acb75242921983f5;
_ScreenSpaceAmbientOcclusion_40f694c4c3ca4e89acb75242921983f5.NDCPosition = IN.NDCPosition;
half _ScreenSpaceAmbientOcclusion_40f694c4c3ca4e89acb75242921983f5_indirectAO_1_Float;
half _ScreenSpaceAmbientOcclusion_40f694c4c3ca4e89acb75242921983f5_directAO_2_Float;
SG_ScreenSpaceAmbientOcclusion_616a08cdf385c2d4997a5ed9d01e16a8_float(_ScreenSpaceAmbientOcclusion_40f694c4c3ca4e89acb75242921983f5, _ScreenSpaceAmbientOcclusion_40f694c4c3ca4e89acb75242921983f5_indirectAO_1_Float, _ScreenSpaceAmbientOcclusion_40f694c4c3ca4e89acb75242921983f5_directAO_2_Float);
float _Property_441143660ff642349088dd1bcab6bc78_Out_0_Float = _Ambient_Occlusion;
float _Minimum_8ee95b9bf7ac4776b6ee4edf1214b3c1_Out_2_Float;
Unity_Minimum_float(_ScreenSpaceAmbientOcclusion_40f694c4c3ca4e89acb75242921983f5_indirectAO_1_Float, _Property_441143660ff642349088dd1bcab6bc78_Out_0_Float, _Minimum_8ee95b9bf7ac4776b6ee4edf1214b3c1_Out_2_Float);
float3 _Property_b171431b5a3b4b0a9fc9fdede4a532a7_Out_0_Vector3 = _Emission;
float3 _Property_db9eb36ed51d4aad95e383920b55e3d7_Out_0_Vector3 = _Normal;
float3 _Transform_9e831bda1f4d4495b24f1f6e3075f2fb_Out_1_Vector3;
{
float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
_Transform_9e831bda1f4d4495b24f1f6e3075f2fb_Out_1_Vector3 = TransformTangentToWorld(_Property_db9eb36ed51d4aad95e383920b55e3d7_Out_0_Vector3.xyz, tangentTransform, true);
}
float3 _Property_4eaab22b2b784aeda3752622f7abaf85_Out_0_Vector3 = _Normal;
float4 _ScreenPosition_121436dfdd464829910775b2326b046b_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
float3 _Property_1b1e0a48277e4883afeb1289a075c5d8_Out_0_Vector3 = _Base_Color;
float3 _LightingComplexityCustomFunction_cbe0c0f96f9046a584e17ead8c001a55_Out_3_Vector3;
LightingComplexity_float((_ScreenPosition_121436dfdd464829910775b2326b046b_Out_0_Vector4.xy), IN.WorldSpacePosition, _Property_1b1e0a48277e4883afeb1289a075c5d8_Out_0_Vector3, _LightingComplexityCustomFunction_cbe0c0f96f9046a584e17ead8c001a55_Out_3_Vector3);
float _Property_dcd3ca7796af45c6857884fa7979898b_Out_0_Float = _Metallic;
float3 _DebugMaterialSwitchCustomFunction_e1fabc2a3bcd4bc183f0e93c379657d4_Out_5_Vector3;
DebugMaterialSwitch_float(_Property_dd011cc96ae64d1181317986b1fa1742_Out_0_Vector3, _Property_5653941ce5a641f18f7ce7012652025d_Out_0_Vector3, float3 (0, 0, 0), (_Property_45f5c13ff5544581bd61c2442cecd0a1_Out_0_Float.xxx), (_Property_b6c8b448c5324bd3bc59540f628e43a3_Out_0_Float.xxx), (_Minimum_8ee95b9bf7ac4776b6ee4edf1214b3c1_Out_2_Float.xxx), _Property_b171431b5a3b4b0a9fc9fdede4a532a7_Out_0_Vector3, _Transform_9e831bda1f4d4495b24f1f6e3075f2fb_Out_1_Vector3, _Property_4eaab22b2b784aeda3752622f7abaf85_Out_0_Vector3, _LightingComplexityCustomFunction_cbe0c0f96f9046a584e17ead8c001a55_Out_3_Vector3, (_Property_dcd3ca7796af45c6857884fa7979898b_Out_0_Float.xxx), float3 (0, 0, 0), float3 (0, 0, 0), _DebugMaterialSwitchCustomFunction_e1fabc2a3bcd4bc183f0e93c379657d4_Out_5_Vector3);
Out_1 = _DebugMaterialSwitchCustomFunction_e1fabc2a3bcd4bc183f0e93c379657d4_Out_5_Vector3;
}

struct Bindings_LitURP_fd8fe8e9e251a39419530ac6ee5a5b61_float
{
float3 WorldSpaceNormal;
float3 WorldSpaceTangent;
float3 WorldSpaceBiTangent;
float3 WorldSpaceViewDirection;
float3 ObjectSpacePosition;
float3 WorldSpacePosition;
float3 AbsoluteWorldSpacePosition;
float2 NDCPosition;
float2 PixelPosition;
half4 uv1;
half4 uv2;
};

void SG_LitURP_fd8fe8e9e251a39419530ac6ee5a5b61_float(float3 _Base_Color, float3 _Normal, float _Metallic, float _Smoothness, float3 _Emission, float _AmbientOcclusion, float _Alpha, Bindings_LitURP_fd8fe8e9e251a39419530ac6ee5a5b61_float IN, out float3 Lit_1)
{
float3 _Property_04a055764411443d802bfbbd0d510c65_Out_0_Vector3 = _Base_Color;
float3 _Property_383a017d83a8420dac016260bc833f58_Out_0_Vector3 = _Normal;
float3 _Transform_3f94cf9dbe844abc9b6727d5d289074f_Out_1_Vector3;
{
float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
_Transform_3f94cf9dbe844abc9b6727d5d289074f_Out_1_Vector3 = TransformTangentToWorld(_Property_383a017d83a8420dac016260bc833f58_Out_0_Vector3.xyz, tangentTransform, true);
}
float _Property_11295d868ff34c388c9212b90b781aff_Out_0_Float = _Metallic;
float _Property_b522b61b85ff4ecbb0eb63cff689f5cb_Out_0_Float = _Smoothness;
float _Property_a1dc37a47c5640d0870861199df0bd70_Out_0_Float = _AmbientOcclusion;
Bindings_ApplyDecals_66e8fc89f7971da4c8964580a0eb9f80_float _ApplyDecals_0413903f5da5491d911d117142eabddd;
_ApplyDecals_0413903f5da5491d911d117142eabddd.PixelPosition = IN.PixelPosition;
half3 _ApplyDecals_0413903f5da5491d911d117142eabddd_BaseColor_1_Vector3;
half3 _ApplyDecals_0413903f5da5491d911d117142eabddd_SpecularColor_2_Vector3;
half3 _ApplyDecals_0413903f5da5491d911d117142eabddd_NormalWS_3_Vector3;
half _ApplyDecals_0413903f5da5491d911d117142eabddd_Metallic_4_Float;
half _ApplyDecals_0413903f5da5491d911d117142eabddd_Smoothness_6_Float;
half _ApplyDecals_0413903f5da5491d911d117142eabddd_AmbientOcclusion_5_Float;
SG_ApplyDecals_66e8fc89f7971da4c8964580a0eb9f80_float(_Property_04a055764411443d802bfbbd0d510c65_Out_0_Vector3, _Transform_3f94cf9dbe844abc9b6727d5d289074f_Out_1_Vector3, _Property_11295d868ff34c388c9212b90b781aff_Out_0_Float, _Property_b522b61b85ff4ecbb0eb63cff689f5cb_Out_0_Float, _Property_a1dc37a47c5640d0870861199df0bd70_Out_0_Float, _ApplyDecals_0413903f5da5491d911d117142eabddd, _ApplyDecals_0413903f5da5491d911d117142eabddd_BaseColor_1_Vector3, _ApplyDecals_0413903f5da5491d911d117142eabddd_SpecularColor_2_Vector3, _ApplyDecals_0413903f5da5491d911d117142eabddd_NormalWS_3_Vector3, _ApplyDecals_0413903f5da5491d911d117142eabddd_Metallic_4_Float, _ApplyDecals_0413903f5da5491d911d117142eabddd_Smoothness_6_Float, _ApplyDecals_0413903f5da5491d911d117142eabddd_AmbientOcclusion_5_Float);
float3 _Property_b986326ad9b34d6ea3a7237ba2bd1cd6_Out_0_Vector3 = _Emission;
Bindings_DebugLighting_61e571d2b9ede1240a524a849d20c997_float _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9;
_DebugLighting_7c013feaa8eb4525bc13d6e4722049d9.WorldSpaceNormal = IN.WorldSpaceNormal;
_DebugLighting_7c013feaa8eb4525bc13d6e4722049d9.WorldSpaceTangent = IN.WorldSpaceTangent;
_DebugLighting_7c013feaa8eb4525bc13d6e4722049d9.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
_DebugLighting_7c013feaa8eb4525bc13d6e4722049d9.WorldSpacePosition = IN.WorldSpacePosition;
_DebugLighting_7c013feaa8eb4525bc13d6e4722049d9.PixelPosition = IN.PixelPosition;
_DebugLighting_7c013feaa8eb4525bc13d6e4722049d9.uv1 = IN.uv1;
_DebugLighting_7c013feaa8eb4525bc13d6e4722049d9.uv2 = IN.uv2;
float3 _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_BaseColor_1_Vector3;
float3 _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Normal_4_Vector3;
float _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Metallic_2_Float;
float _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Smoothness_3_Float;
float3 _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Emission_5_Vector3;
float _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_AmbientOcclusion_6_Float;
SG_DebugLighting_61e571d2b9ede1240a524a849d20c997_float(_ApplyDecals_0413903f5da5491d911d117142eabddd_BaseColor_1_Vector3, _ApplyDecals_0413903f5da5491d911d117142eabddd_NormalWS_3_Vector3, _ApplyDecals_0413903f5da5491d911d117142eabddd_Metallic_4_Float, _ApplyDecals_0413903f5da5491d911d117142eabddd_Smoothness_6_Float, _Property_b986326ad9b34d6ea3a7237ba2bd1cd6_Out_0_Vector3, _ApplyDecals_0413903f5da5491d911d117142eabddd_AmbientOcclusion_5_Float, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_BaseColor_1_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Normal_4_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Metallic_2_Float, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Smoothness_3_Float, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Emission_5_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_AmbientOcclusion_6_Float);
Bindings_LightURP_17836dba1a675e246923104447b19cbd_float _LightURP_4a271a100e74437fb7dc277976b6febf;
_LightURP_4a271a100e74437fb7dc277976b6febf.WorldSpaceNormal = IN.WorldSpaceNormal;
_LightURP_4a271a100e74437fb7dc277976b6febf.WorldSpaceTangent = IN.WorldSpaceTangent;
_LightURP_4a271a100e74437fb7dc277976b6febf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
_LightURP_4a271a100e74437fb7dc277976b6febf.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
_LightURP_4a271a100e74437fb7dc277976b6febf.ObjectSpacePosition = IN.ObjectSpacePosition;
_LightURP_4a271a100e74437fb7dc277976b6febf.WorldSpacePosition = IN.WorldSpacePosition;
_LightURP_4a271a100e74437fb7dc277976b6febf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
_LightURP_4a271a100e74437fb7dc277976b6febf.NDCPosition = IN.NDCPosition;
_LightURP_4a271a100e74437fb7dc277976b6febf.PixelPosition = IN.PixelPosition;
_LightURP_4a271a100e74437fb7dc277976b6febf.uv1 = IN.uv1;
_LightURP_4a271a100e74437fb7dc277976b6febf.uv2 = IN.uv2;
half3 _LightURP_4a271a100e74437fb7dc277976b6febf_Lit_1_Vector3;
SG_LightURP_17836dba1a675e246923104447b19cbd_float(_DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_BaseColor_1_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Normal_4_Vector3, true, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Metallic_2_Float, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Smoothness_3_Float, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_AmbientOcclusion_6_Float, half(1), _LightURP_4a271a100e74437fb7dc277976b6febf, _LightURP_4a271a100e74437fb7dc277976b6febf_Lit_1_Vector3);
float3 _Add_a11e24e7d4fd4494895fd67f375acb21_Out_2_Vector3;
Unity_Add_float3(_LightURP_4a271a100e74437fb7dc277976b6febf_Lit_1_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Emission_5_Vector3, _Add_a11e24e7d4fd4494895fd67f375acb21_Out_2_Vector3);
float _Property_d5e8251fc84a46aea1765511445b653e_Out_0_Float = _Alpha;
Bindings_DebugMaterials_53d20e1f36b55014f99f9ccae649c798_float _DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3;
_DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3.WorldSpaceNormal = IN.WorldSpaceNormal;
_DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3.WorldSpaceTangent = IN.WorldSpaceTangent;
_DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
_DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3.WorldSpacePosition = IN.WorldSpacePosition;
_DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3.NDCPosition = IN.NDCPosition;
float3 _DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3_Out_1_Vector3;
SG_DebugMaterials_53d20e1f36b55014f99f9ccae649c798_float(_Add_a11e24e7d4fd4494895fd67f375acb21_Out_2_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_BaseColor_1_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Normal_4_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Metallic_2_Float, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Smoothness_3_Float, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Emission_5_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_AmbientOcclusion_6_Float, _Property_d5e8251fc84a46aea1765511445b653e_Out_0_Float, _DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3, _DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3_Out_1_Vector3);
Lit_1 = _DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3_Out_1_Vector3;
}

void Unity_ColorspaceConversion_RGB_HSV_float(float3 In, out float3 Out)
{
    float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    float4 P = lerp(float4(In.bg, K.wz), float4(In.gb, K.xy), step(In.b, In.g));
    float4 Q = lerp(float4(P.xyw, In.r), float4(In.r, P.yzx), step(P.x, In.r));
    float D = Q.x - min(Q.w, Q.y);
    float  E = 1e-10;
    float V = (D == 0) ? Q.x : (Q.x + E);
    Out = float3(abs(Q.z + (Q.w - Q.y)/(6.0 * D + E)), D / (Q.x + E), V);
}

void Unity_Floor_float(float In, out float Out)
{
    Out = floor(In);
}

void Unity_Fraction_float(float In, out float Out)
{
    Out = frac(In);
}

void Unity_Power_float(float A, float B, out float Out)
{
    Out = pow(A, B);
}

void Unity_Sign_float(float In, out float Out)
{
    Out = sign(In);
}

struct Bindings_DynamicSCurve_3565967296b1b074e9007137bcb40394_float
{
};

void SG_DynamicSCurve_3565967296b1b074e9007137bcb40394_float(float _Transition_Sharpness, float _Value, Bindings_DynamicSCurve_3565967296b1b074e9007137bcb40394_float IN, out float Output_2)
{
float _Property_dcf147b7545042b199ca74d23fcbd205_Out_0_Float = _Value;
float _Add_eb03fff2d84e49d587a7742a4b9d1911_Out_2_Float;
Unity_Add_float(_Property_dcf147b7545042b199ca74d23fcbd205_Out_0_Float, _Property_dcf147b7545042b199ca74d23fcbd205_Out_0_Float, _Add_eb03fff2d84e49d587a7742a4b9d1911_Out_2_Float);
float _Property_b6803ebab1d14e28a59f3f0620bc01fe_Out_0_Float = _Transition_Sharpness;
float _Clamp_babb9473387444bba43958a0a940ee34_Out_3_Float;
Unity_Clamp_float(_Property_b6803ebab1d14e28a59f3f0620bc01fe_Out_0_Float, float(0), float(0.99), _Clamp_babb9473387444bba43958a0a940ee34_Out_3_Float);
float _OneMinus_d216a1afb61246768fbf941a2d1a8328_Out_1_Float;
Unity_OneMinus_float(_Clamp_babb9473387444bba43958a0a940ee34_Out_3_Float, _OneMinus_d216a1afb61246768fbf941a2d1a8328_Out_1_Float);
float _Divide_34a05d03980341a3971de4b91620a5bf_Out_2_Float;
Unity_Divide_float(float(1), _OneMinus_d216a1afb61246768fbf941a2d1a8328_Out_1_Float, _Divide_34a05d03980341a3971de4b91620a5bf_Out_2_Float);
float _Power_7b42c3f5820c4805814fd7552688ab96_Out_2_Float;
Unity_Power_float(_Add_eb03fff2d84e49d587a7742a4b9d1911_Out_2_Float, _Divide_34a05d03980341a3971de4b91620a5bf_Out_2_Float, _Power_7b42c3f5820c4805814fd7552688ab96_Out_2_Float);
float _Subtract_12c9f1648de341b4a45af3973e5b972c_Out_2_Float;
Unity_Subtract_float(_Property_dcf147b7545042b199ca74d23fcbd205_Out_0_Float, float(0.5), _Subtract_12c9f1648de341b4a45af3973e5b972c_Out_2_Float);
float _Sign_862dd10c92de4dceb317f801dea4f2d9_Out_1_Float;
Unity_Sign_float(_Subtract_12c9f1648de341b4a45af3973e5b972c_Out_2_Float, _Sign_862dd10c92de4dceb317f801dea4f2d9_Out_1_Float);
float _Add_a2d7a5f001944c6496ce3466c7d6c666_Out_2_Float;
Unity_Add_float(_Sign_862dd10c92de4dceb317f801dea4f2d9_Out_1_Float, float(1), _Add_a2d7a5f001944c6496ce3466c7d6c666_Out_2_Float);
float _Subtract_644715ea3c054db6bc12c0813f096086_Out_2_Float;
Unity_Subtract_float(float(2), _Add_a2d7a5f001944c6496ce3466c7d6c666_Out_2_Float, _Subtract_644715ea3c054db6bc12c0813f096086_Out_2_Float);
float _Multiply_d380040a9ebb4cb5b081d93f3444d4bf_Out_2_Float;
Unity_Multiply_float_float(_Power_7b42c3f5820c4805814fd7552688ab96_Out_2_Float, _Subtract_644715ea3c054db6bc12c0813f096086_Out_2_Float, _Multiply_d380040a9ebb4cb5b081d93f3444d4bf_Out_2_Float);
float _Add_42fd94976e7c42e3a174031a3f7ed22f_Out_2_Float;
Unity_Add_float(_Property_dcf147b7545042b199ca74d23fcbd205_Out_0_Float, _Property_dcf147b7545042b199ca74d23fcbd205_Out_0_Float, _Add_42fd94976e7c42e3a174031a3f7ed22f_Out_2_Float);
float _Subtract_9ff8c56779f1472c846929dd11ae8e10_Out_2_Float;
Unity_Subtract_float(float(2), _Add_42fd94976e7c42e3a174031a3f7ed22f_Out_2_Float, _Subtract_9ff8c56779f1472c846929dd11ae8e10_Out_2_Float);
float _Power_db9493c407d3483a8dc3176196107278_Out_2_Float;
Unity_Power_float(_Subtract_9ff8c56779f1472c846929dd11ae8e10_Out_2_Float, _Divide_34a05d03980341a3971de4b91620a5bf_Out_2_Float, _Power_db9493c407d3483a8dc3176196107278_Out_2_Float);
float _Subtract_3dc49412d7464d2abf5ef1de774e77ff_Out_2_Float;
Unity_Subtract_float(float(2), _Power_db9493c407d3483a8dc3176196107278_Out_2_Float, _Subtract_3dc49412d7464d2abf5ef1de774e77ff_Out_2_Float);
float _Multiply_0a00edfeb8e549478444268e9aa69c00_Out_2_Float;
Unity_Multiply_float_float(_Subtract_3dc49412d7464d2abf5ef1de774e77ff_Out_2_Float, _Add_a2d7a5f001944c6496ce3466c7d6c666_Out_2_Float, _Multiply_0a00edfeb8e549478444268e9aa69c00_Out_2_Float);
float _Add_51a37a0e820549b2ace13c24825f6ff3_Out_2_Float;
Unity_Add_float(_Multiply_d380040a9ebb4cb5b081d93f3444d4bf_Out_2_Float, _Multiply_0a00edfeb8e549478444268e9aa69c00_Out_2_Float, _Add_51a37a0e820549b2ace13c24825f6ff3_Out_2_Float);
float _Multiply_3a2c209c0f54499aa9cd11f5bca1ac5e_Out_2_Float;
Unity_Multiply_float_float(_Add_51a37a0e820549b2ace13c24825f6ff3_Out_2_Float, 0.25, _Multiply_3a2c209c0f54499aa9cd11f5bca1ac5e_Out_2_Float);
Output_2 = _Multiply_3a2c209c0f54499aa9cd11f5bca1ac5e_Out_2_Float;
}

void Unity_Log2_float(float In, out float Out)
{
    Out = log2(In);
}

void Unity_ViewVectorWorld_float(out float3 Out, float3 WorldSpacePosition)
{
    Out = _WorldSpaceCameraPos.xyz - GetAbsolutePositionWS(WorldSpacePosition);
    if(!IsPerspectiveProjection())
    {
        Out = GetViewForwardDir() * dot(Out, GetViewForwardDir());
    }
}

void Unity_Arccosine_float(float In, out float Out)
{
    Out = acos(In);
}

void Unity_InverseLerp_float(float A, float B, float T, out float Out)
{
    Out = (T - A)/(B - A);
}

void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
{
    RGBA = float4(R, G, B, A);
    RGB = float3(R, G, B);
    RG = float2(R, G);
}

void Unity_ColorspaceConversion_HSV_RGB_float(float3 In, out float3 Out)
{
    float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    float3 P = abs(frac(In.xxx + K.xyz) * 6.0 - K.www);
    Out = In.z * lerp(K.xxx, saturate(P - K.xxx), In.y);
}

void Unity_Maximum_float3(float3 A, float3 B, out float3 Out)
{
    Out = max(A, B);
}

struct Bindings_CellLightingModel_28d05442c333727418ac448845e1326b_float
{
float3 WorldSpaceNormal;
float3 TangentSpaceNormal;
float3 WorldSpaceTangent;
float3 WorldSpaceBiTangent;
float3 WorldSpaceViewDirection;
float3 ObjectSpacePosition;
float3 WorldSpacePosition;
float3 AbsoluteWorldSpacePosition;
float2 NDCPosition;
float2 PixelPosition;
half4 uv1;
half4 uv2;
};

void SG_CellLightingModel_28d05442c333727418ac448845e1326b_float(float3 _Color, float3 _Normal, bool _Normal_cff37159d27a438f823fbf468c1fb985_IsConnected, float _Metallic, float _Smoothness, float4 _Emission, float _Ambient_Occlusion, float _Transition_Sharpness, float _Posterization, float _Posterization_Sharpness, float _Rim_Light, Bindings_CellLightingModel_28d05442c333727418ac448845e1326b_float IN, out float3 Color_2)
{
float3 _Property_4bd64118369b459398471ea412165b6d_Out_0_Vector3 = _Color;
float3 _Property_45e1be22194d4e5bac9c49dd235276b2_Out_0_Vector3 = _Normal;
bool _Property_45e1be22194d4e5bac9c49dd235276b2_Out_0_Vector3_IsConnected = _Normal_cff37159d27a438f823fbf468c1fb985_IsConnected;
float3 _BranchOnInputConnection_5509e94253aa40279af357154b1bfc82_Out_3_Vector3 = _Property_45e1be22194d4e5bac9c49dd235276b2_Out_0_Vector3_IsConnected ? _Property_45e1be22194d4e5bac9c49dd235276b2_Out_0_Vector3 : IN.TangentSpaceNormal;
float _Property_364c0d0968c04621a0f5089a26f94b35_Out_0_Float = _Metallic;
float _Property_ae8565d0591149cdbe7378e405bcaf4f_Out_0_Float = _Smoothness;
float4 _Property_47156e0140cb41ca8d7230103d68e17f_Out_0_Vector4 = _Emission;
float _Property_aabb3e299af744ee942d6adf77f21f65_Out_0_Float = _Ambient_Occlusion;
Bindings_LitURP_fd8fe8e9e251a39419530ac6ee5a5b61_float _LitURP_79042709b1054141888f9d40874c578b;
_LitURP_79042709b1054141888f9d40874c578b.WorldSpaceNormal = IN.WorldSpaceNormal;
_LitURP_79042709b1054141888f9d40874c578b.WorldSpaceTangent = IN.WorldSpaceTangent;
_LitURP_79042709b1054141888f9d40874c578b.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
_LitURP_79042709b1054141888f9d40874c578b.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
_LitURP_79042709b1054141888f9d40874c578b.ObjectSpacePosition = IN.ObjectSpacePosition;
_LitURP_79042709b1054141888f9d40874c578b.WorldSpacePosition = IN.WorldSpacePosition;
_LitURP_79042709b1054141888f9d40874c578b.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
_LitURP_79042709b1054141888f9d40874c578b.NDCPosition = IN.NDCPosition;
_LitURP_79042709b1054141888f9d40874c578b.PixelPosition = IN.PixelPosition;
_LitURP_79042709b1054141888f9d40874c578b.uv1 = IN.uv1;
_LitURP_79042709b1054141888f9d40874c578b.uv2 = IN.uv2;
half3 _LitURP_79042709b1054141888f9d40874c578b_Lit_1_Vector3;
SG_LitURP_fd8fe8e9e251a39419530ac6ee5a5b61_float(_Property_4bd64118369b459398471ea412165b6d_Out_0_Vector3, _BranchOnInputConnection_5509e94253aa40279af357154b1bfc82_Out_3_Vector3, _Property_364c0d0968c04621a0f5089a26f94b35_Out_0_Float, _Property_ae8565d0591149cdbe7378e405bcaf4f_Out_0_Float, (_Property_47156e0140cb41ca8d7230103d68e17f_Out_0_Vector4.xyz), _Property_aabb3e299af744ee942d6adf77f21f65_Out_0_Float, half(1), _LitURP_79042709b1054141888f9d40874c578b, _LitURP_79042709b1054141888f9d40874c578b_Lit_1_Vector3);
float3 _ColorspaceConversion_6887f2e74d5145928d4dde174bb981cf_Out_1_Vector3;
Unity_ColorspaceConversion_RGB_HSV_float(_LitURP_79042709b1054141888f9d40874c578b_Lit_1_Vector3, _ColorspaceConversion_6887f2e74d5145928d4dde174bb981cf_Out_1_Vector3);
float _Split_2b8b5bbad0b9449cab8a678b7257b571_R_1_Float = _ColorspaceConversion_6887f2e74d5145928d4dde174bb981cf_Out_1_Vector3[0];
float _Split_2b8b5bbad0b9449cab8a678b7257b571_G_2_Float = _ColorspaceConversion_6887f2e74d5145928d4dde174bb981cf_Out_1_Vector3[1];
float _Split_2b8b5bbad0b9449cab8a678b7257b571_B_3_Float = _ColorspaceConversion_6887f2e74d5145928d4dde174bb981cf_Out_1_Vector3[2];
float _Split_2b8b5bbad0b9449cab8a678b7257b571_A_4_Float = 0;
float _Property_07e622f223754e8db9a1c0f144cf4380_Out_0_Float = _Posterization;
float _Multiply_1f3b4aa4180540e6bab2a8a025323a8a_Out_2_Float;
Unity_Multiply_float_float(_Split_2b8b5bbad0b9449cab8a678b7257b571_R_1_Float, _Property_07e622f223754e8db9a1c0f144cf4380_Out_0_Float, _Multiply_1f3b4aa4180540e6bab2a8a025323a8a_Out_2_Float);
float _Floor_c642d1dbc9ee4877b35ab7b2d38aa451_Out_1_Float;
Unity_Floor_float(_Multiply_1f3b4aa4180540e6bab2a8a025323a8a_Out_2_Float, _Floor_c642d1dbc9ee4877b35ab7b2d38aa451_Out_1_Float);
float _Property_2e80548cd7284658a859582545b6f50e_Out_0_Float = _Posterization_Sharpness;
float _Fraction_5a8094c3579a4c5d9cad4520c2b0cd53_Out_1_Float;
Unity_Fraction_float(_Multiply_1f3b4aa4180540e6bab2a8a025323a8a_Out_2_Float, _Fraction_5a8094c3579a4c5d9cad4520c2b0cd53_Out_1_Float);
Bindings_DynamicSCurve_3565967296b1b074e9007137bcb40394_float _DynamicSCurve_e5598a692a07458e80b116ed256a89e8;
half _DynamicSCurve_e5598a692a07458e80b116ed256a89e8_Output_2_Float;
SG_DynamicSCurve_3565967296b1b074e9007137bcb40394_float(_Property_2e80548cd7284658a859582545b6f50e_Out_0_Float, _Fraction_5a8094c3579a4c5d9cad4520c2b0cd53_Out_1_Float, _DynamicSCurve_e5598a692a07458e80b116ed256a89e8, _DynamicSCurve_e5598a692a07458e80b116ed256a89e8_Output_2_Float);
float _Add_a0c65e7457a1437c81294359341c71c8_Out_2_Float;
Unity_Add_float(_Floor_c642d1dbc9ee4877b35ab7b2d38aa451_Out_1_Float, _DynamicSCurve_e5598a692a07458e80b116ed256a89e8_Output_2_Float, _Add_a0c65e7457a1437c81294359341c71c8_Out_2_Float);
float _Property_aab70366cc8c4df6b7a024d6e1337398_Out_0_Float = _Posterization;
float _Divide_0d9855a4588b49d6b8587fe86caf1004_Out_2_Float;
Unity_Divide_float(_Add_a0c65e7457a1437c81294359341c71c8_Out_2_Float, _Property_aab70366cc8c4df6b7a024d6e1337398_Out_0_Float, _Divide_0d9855a4588b49d6b8587fe86caf1004_Out_2_Float);
float _Log_d5b1a70faf044f85b5d12513aff37699_Out_1_Float;
Unity_Log2_float(_Split_2b8b5bbad0b9449cab8a678b7257b571_B_3_Float, _Log_d5b1a70faf044f85b5d12513aff37699_Out_1_Float);
float _Property_42629d56e9b145958e0034bf344ef226_Out_0_Float = _Metallic;
float _Lerp_fd3d6294a8a34ab8bd8d460c6ab37d6c_Out_3_Float;
Unity_Lerp_float(float(1), float(0.3333333), _Property_42629d56e9b145958e0034bf344ef226_Out_0_Float, _Lerp_fd3d6294a8a34ab8bd8d460c6ab37d6c_Out_3_Float);
float _Multiply_f477590b4b5441cf8614bdd0102f5f32_Out_2_Float;
Unity_Multiply_float_float(_Log_d5b1a70faf044f85b5d12513aff37699_Out_1_Float, _Lerp_fd3d6294a8a34ab8bd8d460c6ab37d6c_Out_3_Float, _Multiply_f477590b4b5441cf8614bdd0102f5f32_Out_2_Float);
float _Floor_f42b74c8270a411da0982fd33f20d5e7_Out_1_Float;
Unity_Floor_float(_Multiply_f477590b4b5441cf8614bdd0102f5f32_Out_2_Float, _Floor_f42b74c8270a411da0982fd33f20d5e7_Out_1_Float);
float _Property_b0041d34b8db46bc8dc49539a104dcf1_Out_0_Float = _Transition_Sharpness;
float _Fraction_3ffc6c982b744f51a6871adf86bb6d17_Out_1_Float;
Unity_Fraction_float(_Multiply_f477590b4b5441cf8614bdd0102f5f32_Out_2_Float, _Fraction_3ffc6c982b744f51a6871adf86bb6d17_Out_1_Float);
Bindings_DynamicSCurve_3565967296b1b074e9007137bcb40394_float _DynamicSCurve_3b9f380ef60e4f3a9cc2812aa84ad9f8;
half _DynamicSCurve_3b9f380ef60e4f3a9cc2812aa84ad9f8_Output_2_Float;
SG_DynamicSCurve_3565967296b1b074e9007137bcb40394_float(_Property_b0041d34b8db46bc8dc49539a104dcf1_Out_0_Float, _Fraction_3ffc6c982b744f51a6871adf86bb6d17_Out_1_Float, _DynamicSCurve_3b9f380ef60e4f3a9cc2812aa84ad9f8, _DynamicSCurve_3b9f380ef60e4f3a9cc2812aa84ad9f8_Output_2_Float);
float _Add_5813508d730241179c839276c1892e54_Out_2_Float;
Unity_Add_float(_Floor_f42b74c8270a411da0982fd33f20d5e7_Out_1_Float, _DynamicSCurve_3b9f380ef60e4f3a9cc2812aa84ad9f8_Output_2_Float, _Add_5813508d730241179c839276c1892e54_Out_2_Float);
float _Divide_22314074bf4949c9b861fbcf57045ed9_Out_2_Float;
Unity_Divide_float(_Add_5813508d730241179c839276c1892e54_Out_2_Float, _Lerp_fd3d6294a8a34ab8bd8d460c6ab37d6c_Out_3_Float, _Divide_22314074bf4949c9b861fbcf57045ed9_Out_2_Float);
float _Property_35eb0e2aa90e42ed906d65f1a3bb0d05_Out_0_Float = _Rim_Light;
float3 _ViewVector_adb78a97b2ea44e088f4b7ce40d0e788_Out_0_Vector3;
Unity_ViewVectorWorld_float(_ViewVector_adb78a97b2ea44e088f4b7ce40d0e788_Out_0_Vector3, IN.WorldSpacePosition);
float _DotProduct_01bbb70d17b94183867e005c1726c4ca_Out_2_Float;
Unity_DotProduct_float3(IN.WorldSpaceNormal, _ViewVector_adb78a97b2ea44e088f4b7ce40d0e788_Out_0_Vector3, _DotProduct_01bbb70d17b94183867e005c1726c4ca_Out_2_Float);
float _Arccosine_64537fb734b44dbba3944b8b84b14c77_Out_1_Float;
Unity_Arccosine_float(_DotProduct_01bbb70d17b94183867e005c1726c4ca_Out_2_Float, _Arccosine_64537fb734b44dbba3944b8b84b14c77_Out_1_Float);
float Constant_f8b656ca1af54d90a3ac98731962d541 = 3.141593;
float _Divide_5804454b417d4000b5e575a6c99f4a86_Out_2_Float;
Unity_Divide_float(Constant_f8b656ca1af54d90a3ac98731962d541, float(2), _Divide_5804454b417d4000b5e575a6c99f4a86_Out_2_Float);
float _Divide_e24683ad45714b83bd59841141f1d367_Out_2_Float;
Unity_Divide_float(_Arccosine_64537fb734b44dbba3944b8b84b14c77_Out_1_Float, _Divide_5804454b417d4000b5e575a6c99f4a86_Out_2_Float, _Divide_e24683ad45714b83bd59841141f1d367_Out_2_Float);
float _InverseLerp_800216468ccc4f728e537a04d670b537_Out_3_Float;
Unity_InverseLerp_float(float(0.5), float(0.8), _Divide_e24683ad45714b83bd59841141f1d367_Out_2_Float, _InverseLerp_800216468ccc4f728e537a04d670b537_Out_3_Float);
float _Saturate_79af768e433046d485dd3e7a63f8b39f_Out_1_Float;
Unity_Saturate_float(_InverseLerp_800216468ccc4f728e537a04d670b537_Out_3_Float, _Saturate_79af768e433046d485dd3e7a63f8b39f_Out_1_Float);
float _Multiply_5dbcd77077d141b6895081ed31cddabf_Out_2_Float;
Unity_Multiply_float_float(_Saturate_79af768e433046d485dd3e7a63f8b39f_Out_1_Float, _Saturate_79af768e433046d485dd3e7a63f8b39f_Out_1_Float, _Multiply_5dbcd77077d141b6895081ed31cddabf_Out_2_Float);
float _Split_6d2339d4cb2945c39e9d2d432789b362_R_1_Float = IN.WorldSpaceNormal[0];
float _Split_6d2339d4cb2945c39e9d2d432789b362_G_2_Float = IN.WorldSpaceNormal[1];
float _Split_6d2339d4cb2945c39e9d2d432789b362_B_3_Float = IN.WorldSpaceNormal[2];
float _Split_6d2339d4cb2945c39e9d2d432789b362_A_4_Float = 0;
float _Float_338deda8c30745b5b2a341ffd1b849ef_Out_0_Float = float(2);
float _Multiply_55f5cbcf511146ea8e37e203068e1f2d_Out_2_Float;
Unity_Multiply_float_float(_Split_6d2339d4cb2945c39e9d2d432789b362_G_2_Float, _Float_338deda8c30745b5b2a341ffd1b849ef_Out_0_Float, _Multiply_55f5cbcf511146ea8e37e203068e1f2d_Out_2_Float);
float _Multiply_fea5f8bf00554b0492150da5dea4ff8e_Out_2_Float;
Unity_Multiply_float_float(_Multiply_5dbcd77077d141b6895081ed31cddabf_Out_2_Float, _Multiply_55f5cbcf511146ea8e37e203068e1f2d_Out_2_Float, _Multiply_fea5f8bf00554b0492150da5dea4ff8e_Out_2_Float);
float _Multiply_1fa0fabbd31f4fcc9f2340408b78185e_Out_2_Float;
Unity_Multiply_float_float(_Property_35eb0e2aa90e42ed906d65f1a3bb0d05_Out_0_Float, _Multiply_fea5f8bf00554b0492150da5dea4ff8e_Out_2_Float, _Multiply_1fa0fabbd31f4fcc9f2340408b78185e_Out_2_Float);
float _Add_a58144872ba94e699c6365f9a593891c_Out_2_Float;
Unity_Add_float(_Divide_22314074bf4949c9b861fbcf57045ed9_Out_2_Float, _Multiply_1fa0fabbd31f4fcc9f2340408b78185e_Out_2_Float, _Add_a58144872ba94e699c6365f9a593891c_Out_2_Float);
float _Power_a5916317387c4081aa32d2933570d809_Out_2_Float;
Unity_Power_float(float(2), _Add_a58144872ba94e699c6365f9a593891c_Out_2_Float, _Power_a5916317387c4081aa32d2933570d809_Out_2_Float);
float _Maximum_b7439812414a4be3817cda571c4ec1e2_Out_2_Float;
Unity_Maximum_float(_Power_a5916317387c4081aa32d2933570d809_Out_2_Float, float(0), _Maximum_b7439812414a4be3817cda571c4ec1e2_Out_2_Float);
float4 _Combine_ebb6335325ea4a278687c3cd845f0e6e_RGBA_4_Vector4;
float3 _Combine_ebb6335325ea4a278687c3cd845f0e6e_RGB_5_Vector3;
float2 _Combine_ebb6335325ea4a278687c3cd845f0e6e_RG_6_Vector2;
Unity_Combine_float(_Divide_0d9855a4588b49d6b8587fe86caf1004_Out_2_Float, _Split_2b8b5bbad0b9449cab8a678b7257b571_G_2_Float, _Maximum_b7439812414a4be3817cda571c4ec1e2_Out_2_Float, _Split_2b8b5bbad0b9449cab8a678b7257b571_A_4_Float, _Combine_ebb6335325ea4a278687c3cd845f0e6e_RGBA_4_Vector4, _Combine_ebb6335325ea4a278687c3cd845f0e6e_RGB_5_Vector3, _Combine_ebb6335325ea4a278687c3cd845f0e6e_RG_6_Vector2);
float3 _ColorspaceConversion_3250b73e99a641879c8e577d36c10ad3_Out_1_Vector3;
Unity_ColorspaceConversion_HSV_RGB_float(_Combine_ebb6335325ea4a278687c3cd845f0e6e_RGB_5_Vector3, _ColorspaceConversion_3250b73e99a641879c8e577d36c10ad3_Out_1_Vector3);
float3 _Maximum_1e2393ebc3604d58b11e0e38db091040_Out_2_Vector3;
Unity_Maximum_float3(_ColorspaceConversion_3250b73e99a641879c8e577d36c10ad3_Out_1_Vector3, float3(0, 0, 0), _Maximum_1e2393ebc3604d58b11e0e38db091040_Out_2_Vector3);
Color_2 = _Maximum_1e2393ebc3604d58b11e0e38db091040_Out_2_Vector3;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
description.Position = IN.ObjectSpacePosition;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
float3 BaseColor;
float Alpha;
float AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
float4 _Property_55c5ce2527444284851f451829601335_Out_0_Vector4 = _Color;
UnityTexture2D _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D = UnityBuildTexture2DStructInternal(_Base, sampler_Base, _Base_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.tex, _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.samplerstate, _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
if (_Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4, _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_R_4_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.r;
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_G_5_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.g;
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_B_6_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.b;
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_A_7_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.a;
float4 _Multiply_61f37827eac943e8ae93f89ea0e75526_Out_2_Vector4;
Unity_Multiply_float4_float4(_Property_55c5ce2527444284851f451829601335_Out_0_Vector4, _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4, _Multiply_61f37827eac943e8ae93f89ea0e75526_Out_2_Vector4);
UnityTexture2D _Property_fc20f84db7324d36bceb15e6e11ceecd_Out_0_Texture2D = UnityBuildTexture2DStructInternal(_Normal, sampler_Normal, _Normal_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_fc20f84db7324d36bceb15e6e11ceecd_Out_0_Texture2D.tex, _Property_fc20f84db7324d36bceb15e6e11ceecd_Out_0_Texture2D.samplerstate, _Property_fc20f84db7324d36bceb15e6e11ceecd_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
if (_Property_fc20f84db7324d36bceb15e6e11ceecd_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4, _Property_fc20f84db7324d36bceb15e6e11ceecd_Out_0_Texture2D.hdrDecode);
_SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4);
float _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_R_4_Float = _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4.r;
float _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_G_5_Float = _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4.g;
float _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_B_6_Float = _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4.b;
float _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_A_7_Float = _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4.a;
UnityTexture2D _Property_92e95d909f834786a128db3d4630a44b_Out_0_Texture2D = UnityBuildTexture2DStructInternal(_Metallic_Smoothness, sampler_Metallic_Smoothness, _Metallic_Smoothness_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_92e95d909f834786a128db3d4630a44b_Out_0_Texture2D.tex, _Property_92e95d909f834786a128db3d4630a44b_Out_0_Texture2D.samplerstate, _Property_92e95d909f834786a128db3d4630a44b_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
if (_Property_92e95d909f834786a128db3d4630a44b_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_RGBA_0_Vector4, _Property_92e95d909f834786a128db3d4630a44b_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_R_4_Float = _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_RGBA_0_Vector4.r;
float _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_G_5_Float = _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_RGBA_0_Vector4.g;
float _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_B_6_Float = _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_RGBA_0_Vector4.b;
float _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_A_7_Float = _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_RGBA_0_Vector4.a;
UnityTexture2D _Property_67a0baf82c6944c794901261ce853689_Out_0_Texture2D = UnityBuildTexture2DStructInternal(_Emissive, sampler_Emissive, _Emissive_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_67a0baf82c6944c794901261ce853689_Out_0_Texture2D.tex, _Property_67a0baf82c6944c794901261ce853689_Out_0_Texture2D.samplerstate, _Property_67a0baf82c6944c794901261ce853689_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
if (_Property_67a0baf82c6944c794901261ce853689_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_RGBA_0_Vector4, _Property_67a0baf82c6944c794901261ce853689_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_R_4_Float = _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_RGBA_0_Vector4.r;
float _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_G_5_Float = _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_RGBA_0_Vector4.g;
float _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_B_6_Float = _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_RGBA_0_Vector4.b;
float _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_A_7_Float = _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_RGBA_0_Vector4.a;
float _Property_737a7264eace4aea95a66c4d180a7185_Out_0_Float = _Emissive_Intensity;
float4 _Multiply_1aa7109ad0954efcb2fe516c58411c07_Out_2_Vector4;
Unity_Multiply_float4_float4(_SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_RGBA_0_Vector4, (_Property_737a7264eace4aea95a66c4d180a7185_Out_0_Float.xxxx), _Multiply_1aa7109ad0954efcb2fe516c58411c07_Out_2_Vector4);
float _Property_723bcef9d5144a12a1dca50553bdb967_Out_0_Float = _Transition_Sharpness;
float _Property_fbfc24be29d34dac98d3e99017691876_Out_0_Float = _Posterization;
float _Property_046028dd74834f0aaeb44803d6ad4c72_Out_0_Float = _Posterization_Sharpness;
float _Property_6cbdfa1aaa89402a8ef11aa9addda98f_Out_0_Float = _Rim_Light;
Bindings_CellLightingModel_28d05442c333727418ac448845e1326b_float _CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.WorldSpaceNormal = IN.WorldSpaceNormal;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.TangentSpaceNormal = IN.TangentSpaceNormal;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.WorldSpaceTangent = IN.WorldSpaceTangent;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.ObjectSpacePosition = IN.ObjectSpacePosition;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.WorldSpacePosition = IN.WorldSpacePosition;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.NDCPosition = IN.NDCPosition;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.PixelPosition = IN.PixelPosition;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.uv1 = IN.uv1;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.uv2 = IN.uv2;
float3 _CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2_Color_2_Vector3;
SG_CellLightingModel_28d05442c333727418ac448845e1326b_float((_Multiply_61f37827eac943e8ae93f89ea0e75526_Out_2_Vector4.xyz), (_SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4.xyz), true, _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_R_4_Float, _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_A_7_Float, _Multiply_1aa7109ad0954efcb2fe516c58411c07_Out_2_Vector4, float(1), _Property_723bcef9d5144a12a1dca50553bdb967_Out_0_Float, _Property_fbfc24be29d34dac98d3e99017691876_Out_0_Float, _Property_046028dd74834f0aaeb44803d6ad4c72_Out_0_Float, _Property_6cbdfa1aaa89402a8ef11aa9addda98f_Out_0_Float, _CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2, _CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2_Color_2_Vector3);
surface.BaseColor = _CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2_Color_2_Vector3;
surface.Alpha = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_A_7_Float;
surface.AlphaClipThreshold = float(0.5);
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
#if VFX_USE_GRAPH_VALUES
    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
#endif
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    

    // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
    float3 unnormalizedNormalWS = input.normalWS;
    const float renormFactor = 1.0 / length(unnormalizedNormalWS);

    // use bitangent on the fly like in hdrp
    // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
    float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
    float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);

    output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);

    // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
    // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
    output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
    output.WorldSpaceBiTangent = renormFactor * bitang;

    output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
    output.WorldSpacePosition = input.positionWS;
    output.ObjectSpacePosition = TransformWorldToObject(input.positionWS);
    output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);

    #if UNITY_UV_STARTS_AT_TOP
    output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
    #else
    output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
    #endif

    output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
    output.NDCPosition.y = 1.0f - output.NDCPosition.y;

    output.uv0 = input.texCoord0;
    output.uv1 = input.texCoord1;
    output.uv2 = input.texCoord2;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "DepthOnly"
    Tags
    {
        "LightMode" = "DepthOnly"
    }

// Render State
Cull [_Cull]
ZTest LEqual
ZWrite On
ColorMask R

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 2.0
#pragma multi_compile_instancing
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma shader_feature_local_fragment _ _ALPHATEST_ON
#pragma multi_compile_local _ _MAIN_LIGHT_SHADOWS
#pragma multi_compile_local _ _ADDITIONAL_LIGHT_SHADOWS
#pragma multi_compile_local _ _MAIN_LIGHT_SHADOWS_CASCADE
#pragma multi_compile_local _ _SHADOWS_SOFT
#pragma multi_compile_local _ _ADDITIONAL_LIGHTS
#pragma multi_compile_local _ _LIGHTMAP_SHADOW_MIXING
#pragma multi_compile_local _ _SHADOW_MASKS
#pragma multi_compile_local _ _CLUSTER_LIGHT_LOOP
#pragma multi_compile_local _ _REFLECTION_PROBE_ATLAS
#pragma multi_compile_local _ _REFLECTION_PROBE_BOX_PROJECTION
#pragma multi_compile_local _ _REFLECTION_PROBE_BLENDING



// Defines

#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
#define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
#define VARYINGS_NEED_TEXCOORD0
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEPTHONLY


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float4 uv0;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0 : INTERP0;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.texCoord0.xyzw = input.texCoord0;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
output.texCoord0 = input.texCoord0.xyzw;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
float _Transition_Sharpness;
float _Posterization;
float _Posterization_Sharpness;
float _Rim_Light;
float4 _Base_TexelSize;
float4 _Normal_TexelSize;
float4 _Color;
float4 _Metallic_Smoothness_TexelSize;
float4 _Emissive_TexelSize;
float _Emissive_Intensity;
UNITY_TEXTURE_STREAMING_DEBUG_VARS;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_Base);
SAMPLER(sampler_Base);
TEXTURE2D(_Normal);
SAMPLER(sampler_Normal);
TEXTURE2D(_Metallic_Smoothness);
SAMPLER(sampler_Metallic_Smoothness);
TEXTURE2D(_Emissive);
SAMPLER(sampler_Emissive);

// Graph Includes
// GraphIncludes: <None>

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions
// GraphFunctions: <None>

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
description.Position = IN.ObjectSpacePosition;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
float Alpha;
float AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
UnityTexture2D _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D = UnityBuildTexture2DStructInternal(_Base, sampler_Base, _Base_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.tex, _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.samplerstate, _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
if (_Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4, _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_R_4_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.r;
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_G_5_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.g;
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_B_6_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.b;
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_A_7_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.a;
surface.Alpha = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_A_7_Float;
surface.AlphaClipThreshold = float(0.5);
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
#if VFX_USE_GRAPH_VALUES
    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
#endif
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    






    #if UNITY_UV_STARTS_AT_TOP
    #else
    #endif


    output.uv0 = input.texCoord0;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "MotionVectors"
    Tags
    {
        "LightMode" = "MotionVectors"
    }

// Render State
Cull [_Cull]
ZTest LEqual
ZWrite On
ColorMask RG

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 3.5
#pragma multi_compile_instancing
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma shader_feature_local_fragment _ _ALPHATEST_ON
#pragma multi_compile_local _ _MAIN_LIGHT_SHADOWS
#pragma multi_compile_local _ _ADDITIONAL_LIGHT_SHADOWS
#pragma multi_compile_local _ _MAIN_LIGHT_SHADOWS_CASCADE
#pragma multi_compile_local _ _SHADOWS_SOFT
#pragma multi_compile_local _ _ADDITIONAL_LIGHTS
#pragma multi_compile_local _ _LIGHTMAP_SHADOW_MIXING
#pragma multi_compile_local _ _SHADOW_MASKS
#pragma multi_compile_local _ _CLUSTER_LIGHT_LOOP
#pragma multi_compile_local _ _REFLECTION_PROBE_ATLAS
#pragma multi_compile_local _ _REFLECTION_PROBE_BOX_PROJECTION
#pragma multi_compile_local _ _REFLECTION_PROBE_BLENDING



// Defines

#define ATTRIBUTES_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD0
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_MOTION_VECTORS


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float4 uv0 : TEXCOORD0;
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float4 uv0;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0 : INTERP0;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.texCoord0.xyzw = input.texCoord0;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
output.texCoord0 = input.texCoord0.xyzw;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
float _Transition_Sharpness;
float _Posterization;
float _Posterization_Sharpness;
float _Rim_Light;
float4 _Base_TexelSize;
float4 _Normal_TexelSize;
float4 _Color;
float4 _Metallic_Smoothness_TexelSize;
float4 _Emissive_TexelSize;
float _Emissive_Intensity;
UNITY_TEXTURE_STREAMING_DEBUG_VARS;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_Base);
SAMPLER(sampler_Base);
TEXTURE2D(_Normal);
SAMPLER(sampler_Normal);
TEXTURE2D(_Metallic_Smoothness);
SAMPLER(sampler_Metallic_Smoothness);
TEXTURE2D(_Emissive);
SAMPLER(sampler_Emissive);

// Graph Includes
// GraphIncludes: <None>

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions
// GraphFunctions: <None>

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
description.Position = IN.ObjectSpacePosition;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
float Alpha;
float AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
UnityTexture2D _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D = UnityBuildTexture2DStructInternal(_Base, sampler_Base, _Base_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.tex, _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.samplerstate, _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
if (_Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4, _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_R_4_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.r;
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_G_5_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.g;
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_B_6_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.b;
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_A_7_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.a;
surface.Alpha = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_A_7_Float;
surface.AlphaClipThreshold = float(0.5);
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpacePosition =                        input.positionOS;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
#if VFX_USE_GRAPH_VALUES
    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
#endif
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    






    #if UNITY_UV_STARTS_AT_TOP
    #else
    #endif


    output.uv0 = input.texCoord0;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/MotionVectorPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "DepthNormalsOnly"
    Tags
    {
        "LightMode" = "DepthNormalsOnly"
    }

// Render State
Cull [_Cull]
ZTest LEqual
ZWrite On

        // Stencil Buffer Setup
        Stencil
        {
            Ref [_StencilRef]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
            Comp [_StencilComp]
            Pass [_StencilPass]
            Fail [_StencilFail]
            ZFail [_StencilZFail]
        }

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 2.0
#pragma multi_compile_instancing
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
#pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
#pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
#pragma shader_feature_local_fragment _ _ALPHAMODULATE_ON
#pragma shader_feature_local_fragment _ _ALPHATEST_ON
#pragma multi_compile_local _ _MAIN_LIGHT_SHADOWS
#pragma multi_compile_local _ _ADDITIONAL_LIGHT_SHADOWS
#pragma multi_compile_local _ _MAIN_LIGHT_SHADOWS_CASCADE
#pragma multi_compile_local _ _SHADOWS_SOFT
#pragma multi_compile_local _ _ADDITIONAL_LIGHTS
#pragma multi_compile_local _ _LIGHTMAP_SHADOW_MIXING
#pragma multi_compile_local _ _SHADOW_MASKS
#pragma multi_compile_local _ _CLUSTER_LIGHT_LOOP
#pragma multi_compile_local _ _REFLECTION_PROBE_ATLAS
#pragma multi_compile_local _ _REFLECTION_PROBE_BOX_PROJECTION
#pragma multi_compile_local _ _REFLECTION_PROBE_BLENDING



// Defines

#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
#define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
#define VARYINGS_NEED_NORMAL_WS
#define VARYINGS_NEED_TEXCOORD0
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEPTHNORMALSONLY


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 normalWS;
 float4 texCoord0;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float4 uv0;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0 : INTERP0;
 float3 normalWS : INTERP1;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.texCoord0.xyzw = input.texCoord0;
output.normalWS.xyz = input.normalWS;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
output.texCoord0 = input.texCoord0.xyzw;
output.normalWS = input.normalWS.xyz;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
float _Transition_Sharpness;
float _Posterization;
float _Posterization_Sharpness;
float _Rim_Light;
float4 _Base_TexelSize;
float4 _Normal_TexelSize;
float4 _Color;
float4 _Metallic_Smoothness_TexelSize;
float4 _Emissive_TexelSize;
float _Emissive_Intensity;
UNITY_TEXTURE_STREAMING_DEBUG_VARS;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_Base);
SAMPLER(sampler_Base);
TEXTURE2D(_Normal);
SAMPLER(sampler_Normal);
TEXTURE2D(_Metallic_Smoothness);
SAMPLER(sampler_Metallic_Smoothness);
TEXTURE2D(_Emissive);
SAMPLER(sampler_Emissive);

// Graph Includes
// GraphIncludes: <None>

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions
// GraphFunctions: <None>

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
description.Position = IN.ObjectSpacePosition;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
float Alpha;
float AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
UnityTexture2D _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D = UnityBuildTexture2DStructInternal(_Base, sampler_Base, _Base_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.tex, _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.samplerstate, _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
if (_Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4, _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_R_4_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.r;
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_G_5_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.g;
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_B_6_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.b;
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_A_7_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.a;
surface.Alpha = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_A_7_Float;
surface.AlphaClipThreshold = float(0.5);
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
#if VFX_USE_GRAPH_VALUES
    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
#endif
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    






    #if UNITY_UV_STARTS_AT_TOP
    #else
    #endif


    output.uv0 = input.texCoord0;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "ShadowCaster"
    Tags
    {
        "LightMode" = "ShadowCaster"
    }

// Render State
Cull [_Cull]
ZTest LEqual
ZWrite On
ColorMask 0

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 2.0
#pragma multi_compile_instancing
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
#pragma shader_feature_local_fragment _ _ALPHATEST_ON
#pragma multi_compile_local _ _MAIN_LIGHT_SHADOWS
#pragma multi_compile_local _ _ADDITIONAL_LIGHT_SHADOWS
#pragma multi_compile_local _ _MAIN_LIGHT_SHADOWS_CASCADE
#pragma multi_compile_local _ _SHADOWS_SOFT
#pragma multi_compile_local _ _ADDITIONAL_LIGHTS
#pragma multi_compile_local _ _LIGHTMAP_SHADOW_MIXING
#pragma multi_compile_local _ _SHADOW_MASKS
#pragma multi_compile_local _ _CLUSTER_LIGHT_LOOP
#pragma multi_compile_local _ _REFLECTION_PROBE_ATLAS
#pragma multi_compile_local _ _REFLECTION_PROBE_BOX_PROJECTION
#pragma multi_compile_local _ _REFLECTION_PROBE_BLENDING



// Defines

#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
#define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
#define VARYINGS_NEED_NORMAL_WS
#define VARYINGS_NEED_TEXCOORD0
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_SHADOWCASTER


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 normalWS;
 float4 texCoord0;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float4 uv0;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0 : INTERP0;
 float3 normalWS : INTERP1;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.texCoord0.xyzw = input.texCoord0;
output.normalWS.xyz = input.normalWS;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
output.texCoord0 = input.texCoord0.xyzw;
output.normalWS = input.normalWS.xyz;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
float _Transition_Sharpness;
float _Posterization;
float _Posterization_Sharpness;
float _Rim_Light;
float4 _Base_TexelSize;
float4 _Normal_TexelSize;
float4 _Color;
float4 _Metallic_Smoothness_TexelSize;
float4 _Emissive_TexelSize;
float _Emissive_Intensity;
UNITY_TEXTURE_STREAMING_DEBUG_VARS;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_Base);
SAMPLER(sampler_Base);
TEXTURE2D(_Normal);
SAMPLER(sampler_Normal);
TEXTURE2D(_Metallic_Smoothness);
SAMPLER(sampler_Metallic_Smoothness);
TEXTURE2D(_Emissive);
SAMPLER(sampler_Emissive);

// Graph Includes
// GraphIncludes: <None>

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions
// GraphFunctions: <None>

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
description.Position = IN.ObjectSpacePosition;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
float Alpha;
float AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
UnityTexture2D _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D = UnityBuildTexture2DStructInternal(_Base, sampler_Base, _Base_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.tex, _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.samplerstate, _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
if (_Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4, _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_R_4_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.r;
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_G_5_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.g;
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_B_6_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.b;
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_A_7_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.a;
surface.Alpha = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_A_7_Float;
surface.AlphaClipThreshold = float(0.5);
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
#if VFX_USE_GRAPH_VALUES
    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
#endif
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    






    #if UNITY_UV_STARTS_AT_TOP
    #else
    #endif


    output.uv0 = input.texCoord0;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "GBuffer"
    Tags
    {
        "LightMode" = "UniversalGBuffer"
    }

// Render State
Cull [_Cull]
Blend [_SrcBlend] [_DstBlend], [_SrcBlendAlpha] [_DstBlendAlpha]
ZTest [_ZTest]
ZWrite [_ZWrite]

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 4.5
#pragma exclude_renderers gles3 glcore
#pragma multi_compile_instancing
#pragma instancing_options renderinglayer
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
#pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
#pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
#pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
#pragma multi_compile _ SHADOWS_SHADOWMASK
#pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
#pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
#pragma shader_feature_local_fragment _ _ALPHAMODULATE_ON
#pragma shader_feature_local_fragment _ _ALPHATEST_ON
#pragma multi_compile_local _ _MAIN_LIGHT_SHADOWS
#pragma multi_compile_local _ _ADDITIONAL_LIGHT_SHADOWS
#pragma multi_compile_local _ _MAIN_LIGHT_SHADOWS_CASCADE
#pragma multi_compile_local _ _SHADOWS_SOFT
#pragma multi_compile_local _ _ADDITIONAL_LIGHTS
#pragma multi_compile_local _ _LIGHTMAP_SHADOW_MIXING
#pragma multi_compile_local _ _SHADOW_MASKS
#pragma multi_compile_local _ _CLUSTER_LIGHT_LOOP
#pragma multi_compile_local _ _REFLECTION_PROBE_ATLAS
#pragma multi_compile_local _ _REFLECTION_PROBE_BOX_PROJECTION
#pragma multi_compile_local _ _REFLECTION_PROBE_BLENDING



// Defines

#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_TEXCOORD2
#define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
#define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
#define VARYINGS_NEED_POSITION_WS
#define VARYINGS_NEED_NORMAL_WS
#define VARYINGS_NEED_TANGENT_WS
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_TEXCOORD2
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_GBUFFER


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 uv2 : TEXCOORD2;
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 positionWS;
 float3 normalWS;
 float4 tangentWS;
 float4 texCoord0;
 float4 texCoord1;
 float4 texCoord2;
#if !defined(LIGHTMAP_ON)
 float3 sh;
#endif
#if defined(USE_APV_PROBE_OCCLUSION)
 float4 probeOcclusion;
#endif
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float3 WorldSpaceNormal;
 float3 TangentSpaceNormal;
 float3 WorldSpaceTangent;
 float3 WorldSpaceBiTangent;
 float3 WorldSpaceViewDirection;
 float3 ObjectSpacePosition;
 float3 WorldSpacePosition;
 float3 AbsoluteWorldSpacePosition;
 float2 NDCPosition;
 float2 PixelPosition;
 float4 uv0;
 float4 uv1;
 float4 uv2;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
#if !defined(LIGHTMAP_ON)
 float3 sh : INTERP0;
#endif
#if defined(USE_APV_PROBE_OCCLUSION)
 float4 probeOcclusion : INTERP1;
#endif
 float4 tangentWS : INTERP2;
 float4 texCoord0 : INTERP3;
 float4 texCoord1 : INTERP4;
 float4 texCoord2 : INTERP5;
 float3 positionWS : INTERP6;
 float3 normalWS : INTERP7;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
#if !defined(LIGHTMAP_ON)
output.sh = input.sh;
#endif
#if defined(USE_APV_PROBE_OCCLUSION)
output.probeOcclusion = input.probeOcclusion;
#endif
output.tangentWS.xyzw = input.tangentWS;
output.texCoord0.xyzw = input.texCoord0;
output.texCoord1.xyzw = input.texCoord1;
output.texCoord2.xyzw = input.texCoord2;
output.positionWS.xyz = input.positionWS;
output.normalWS.xyz = input.normalWS;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
#if !defined(LIGHTMAP_ON)
output.sh = input.sh;
#endif
#if defined(USE_APV_PROBE_OCCLUSION)
output.probeOcclusion = input.probeOcclusion;
#endif
output.tangentWS = input.tangentWS.xyzw;
output.texCoord0 = input.texCoord0.xyzw;
output.texCoord1 = input.texCoord1.xyzw;
output.texCoord2 = input.texCoord2.xyzw;
output.positionWS = input.positionWS.xyz;
output.normalWS = input.normalWS.xyz;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
float _Transition_Sharpness;
float _Posterization;
float _Posterization_Sharpness;
float _Rim_Light;
float4 _Base_TexelSize;
float4 _Normal_TexelSize;
float4 _Color;
float4 _Metallic_Smoothness_TexelSize;
float4 _Emissive_TexelSize;
float _Emissive_Intensity;
UNITY_TEXTURE_STREAMING_DEBUG_VARS;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_Base);
SAMPLER(sampler_Base);
TEXTURE2D(_Normal);
SAMPLER(sampler_Normal);
TEXTURE2D(_Metallic_Smoothness);
SAMPLER(sampler_Metallic_Smoothness);
TEXTURE2D(_Emissive);
SAMPLER(sampler_Emissive);

// Graph Includes
#include_with_pragmas "Assets/Art/Shaders/Custom Lighting/Components/Debug/DebugLightingComplexity.hlsl"

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Divide_half(half A, half B, out half Out)
{
    Out = A / B;
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_OneMinus_half(half In, out half Out)
{
    Out = 1 - In;
}

void Unity_Multiply_float_float(float A, float B, out float Out)
{
Out = A * B;
}

void Unity_Multiply_half_half(half A, half B, out half Out)
{
Out = A * B;
}

// unity-custom-func-begin
void ApplyDecals_float(float4 positionCS, float3 baseColor, float3 specularColor, float3 normalWS, float metallic, float smoothness, float occlusion, out float3 baseColorOut, out float3 specularColorOut, out float3 normalWSOut, out float metallicOut, out float smoothnessOut, out float occlusionOut){
#if !defined(SHADERGRAPH_PREVIEW) && defined(_DBUFFER)
	ApplyDecal(positionCS, baseColor, specularColor, normalWS, metallic, occlusion, smoothness);
	baseColorOut = baseColor;
	specularColorOut = specularColor;
	normalWSOut = normalWS;
	metallicOut = metallic;
	occlusionOut = occlusion;
	smoothnessOut = smoothness;
#else
	baseColorOut = baseColor;
	specularColorOut = specularColor;
	normalWSOut = normalWS;
	metallicOut = metallic;
	occlusionOut = occlusion;
	smoothnessOut = smoothness;
#endif
}
// unity-custom-func-end

struct Bindings_ApplyDecals_66e8fc89f7971da4c8964580a0eb9f80_float
{
float2 PixelPosition;
};

void SG_ApplyDecals_66e8fc89f7971da4c8964580a0eb9f80_float(float3 _Base_Color, float3 _NormalWS, float _Metallic, float _Smoothness, float _AmbientOcclusion, Bindings_ApplyDecals_66e8fc89f7971da4c8964580a0eb9f80_float IN, out float3 BaseColor_1, out float3 SpecularColor_2, out float3 NormalWS_3, out float Metallic_4, out float Smoothness_6, out float AmbientOcclusion_5)
{
float4 _ScreenPosition_475ffbde1b774459b0d45276e537a836_Out_0_Vector4 = float4(IN.PixelPosition.xy, 0, 0);
float _Split_ad27d29658ef44f7b6941c97694d6866_R_1_Float = _ScreenPosition_475ffbde1b774459b0d45276e537a836_Out_0_Vector4[0];
float _Split_ad27d29658ef44f7b6941c97694d6866_G_2_Float = _ScreenPosition_475ffbde1b774459b0d45276e537a836_Out_0_Vector4[1];
float _Split_ad27d29658ef44f7b6941c97694d6866_B_3_Float = _ScreenPosition_475ffbde1b774459b0d45276e537a836_Out_0_Vector4[2];
float _Split_ad27d29658ef44f7b6941c97694d6866_A_4_Float = _ScreenPosition_475ffbde1b774459b0d45276e537a836_Out_0_Vector4[3];
float _Divide_3f9fb3b7b5b94d0d8246bbc34aa63f7b_Out_2_Float;
Unity_Divide_float(_Split_ad27d29658ef44f7b6941c97694d6866_G_2_Float, _ScreenParams.y, _Divide_3f9fb3b7b5b94d0d8246bbc34aa63f7b_Out_2_Float);
float _OneMinus_3cfec48ba27f4585a5feb790836dc9dc_Out_1_Float;
Unity_OneMinus_float(_Divide_3f9fb3b7b5b94d0d8246bbc34aa63f7b_Out_2_Float, _OneMinus_3cfec48ba27f4585a5feb790836dc9dc_Out_1_Float);
float _Multiply_a4baed73797c41c1b9631ae9bbddfe12_Out_2_Float;
Unity_Multiply_float_float(_OneMinus_3cfec48ba27f4585a5feb790836dc9dc_Out_1_Float, _ScreenParams.y, _Multiply_a4baed73797c41c1b9631ae9bbddfe12_Out_2_Float);
float2 _Vector2_eed86f79e1de4c188df97eb091955bc5_Out_0_Vector2 = float2(_Split_ad27d29658ef44f7b6941c97694d6866_R_1_Float, _Multiply_a4baed73797c41c1b9631ae9bbddfe12_Out_2_Float);
float3 _Property_6219e38e66a84dddb55188eb0359a8c3_Out_0_Vector3 = _Base_Color;
float3 _Property_f4c37d8281c1497e8dab743349080d88_Out_0_Vector3 = _NormalWS;
float _Property_0826181079c84604befc19a2460f4daa_Out_0_Float = _Metallic;
float _Property_d54a743184cc4f27b93d5f5b239c7b7e_Out_0_Float = _Smoothness;
float _Property_bd6cbdae9db240b9b4ad935655106f79_Out_0_Float = _AmbientOcclusion;
float3 _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_baseColorOut_8_Vector3;
float3 _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_specularColorOut_9_Vector3;
float3 _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_normalWSOut_10_Vector3;
float _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_metallicOut_11_Float;
float _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_smoothnessOut_13_Float;
float _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_occlusionOut_12_Float;
ApplyDecals_float((float4(_Vector2_eed86f79e1de4c188df97eb091955bc5_Out_0_Vector2, 0.0, 1.0)), _Property_6219e38e66a84dddb55188eb0359a8c3_Out_0_Vector3, float3 (0, 0, 0), _Property_f4c37d8281c1497e8dab743349080d88_Out_0_Vector3, _Property_0826181079c84604befc19a2460f4daa_Out_0_Float, _Property_d54a743184cc4f27b93d5f5b239c7b7e_Out_0_Float, _Property_bd6cbdae9db240b9b4ad935655106f79_Out_0_Float, _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_baseColorOut_8_Vector3, _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_specularColorOut_9_Vector3, _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_normalWSOut_10_Vector3, _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_metallicOut_11_Float, _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_smoothnessOut_13_Float, _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_occlusionOut_12_Float);
BaseColor_1 = _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_baseColorOut_8_Vector3;
SpecularColor_2 = _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_specularColorOut_9_Vector3;
NormalWS_3 = _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_normalWSOut_10_Vector3;
Metallic_4 = _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_metallicOut_11_Float;
Smoothness_6 = _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_smoothnessOut_13_Float;
AmbientOcclusion_5 = _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_occlusionOut_12_Float;
}

// unity-custom-func-begin
void SwitchLightingDebug_float(float3 BaseColorIn, float3 NormalIn, float MetallicIn, float SmoothnessIn, float3 EmissionIn, float AmbientOcclusionIn, float3 positionWS, float3 bakedGI, out float3 BaseColorOut, out float3 NormalOut, out float MetallicOut, out float SmoothnessOut, out float3 EmissionOut, out float AmbientOcclusionOut){
#if !defined(SHADERGRAPH_PREVIEW) && defined(DEBUG_DISPLAY)

[branch] switch(int(_DebugLightingMode))

{

    case 0: //none

		BaseColorOut = BaseColorIn;

		MetallicOut = MetallicIn;

		SmoothnessOut = SmoothnessIn;

		NormalOut = NormalIn;

		EmissionOut = EmissionIn;

		AmbientOcclusionOut = AmbientOcclusionIn;

		break;

    case 1: //SHADOW_CASCADES

		half cascadeIndex = ComputeCascadeIndex(positionWS);

		switch (uint(cascadeIndex))

		{

			case 0: BaseColorOut = kDebugColorShadowCascade0.rgb;break;

			case 1: BaseColorOut = kDebugColorShadowCascade1.rgb;break;

			case 2: BaseColorOut = kDebugColorShadowCascade2.rgb;break;

			case 3: BaseColorOut = kDebugColorShadowCascade3.rgb;break;

			default: BaseColorOut = kDebugColorBlack.rgb;break;

		}

		MetallicOut = MetallicIn;

		SmoothnessOut = SmoothnessIn;

		NormalOut = NormalIn;

		EmissionOut = EmissionIn;

		AmbientOcclusionOut = AmbientOcclusionIn;

		break;

    case 2: //LIGHTING_WITHOUT_NORMAL_MAPS

		BaseColorOut = float3(1,1,1);

		MetallicOut = 0;

		SmoothnessOut = 0;

		NormalOut = float3(0,0,1);

		EmissionOut = float3(0,0,0);

		AmbientOcclusionOut = 1;

		break;

    case 3: //LIGHTING_WITH_NORMAL_MAPS

		BaseColorOut = float3(1,1,1);

		MetallicOut = 0;

		SmoothnessOut = 0;

		NormalOut = NormalIn;

		EmissionOut = float3(0,0,0);

		AmbientOcclusionOut = 1;

		break;

    case 4: //REFLECTIONS

		BaseColorOut = float3(0.1,0.1,0.1);

		MetallicOut = 1;

		SmoothnessOut = 1;

		NormalOut = float3(0,0,1);

		EmissionOut = float3(0,0,0);

		AmbientOcclusionOut = 1;

		break;

    case 5: //REFLECTIONS_WITH_SMOOTHNESS

		BaseColorOut = float3(0.1,0.1,0.1);

		MetallicOut = 1;

		SmoothnessOut = SmoothnessIn;

		NormalOut = NormalIn;

		EmissionOut = float3(0,0,0);

		AmbientOcclusionOut = AmbientOcclusionIn;

		break;

    case 6: //GLOBAL_ILLUM

		BaseColorOut = bakedGI;

		MetallicOut = MetallicIn;

		SmoothnessOut = 0;

		NormalOut = float3(0,0,1);

		EmissionOut = float3(0,0,0);

		AmbientOcclusionOut = 1;

		break;

    default:

		BaseColorOut = BaseColorIn;

		MetallicOut = MetallicIn;

		SmoothnessOut = SmoothnessIn;

		NormalOut = NormalIn;

		EmissionOut = EmissionIn;

		AmbientOcclusionOut = AmbientOcclusionIn;

		break;

}

#else

		BaseColorOut = BaseColorIn;

		MetallicOut = MetallicIn;

		SmoothnessOut = SmoothnessIn;

		NormalOut = NormalIn;

		EmissionOut = EmissionIn;

		AmbientOcclusionOut = AmbientOcclusionIn;

#endif
}
// unity-custom-func-end

struct Bindings_DebugLighting_61e571d2b9ede1240a524a849d20c997_float
{
float3 WorldSpaceNormal;
float3 WorldSpaceTangent;
float3 WorldSpaceBiTangent;
float3 WorldSpacePosition;
float2 PixelPosition;
half4 uv1;
half4 uv2;
};

void SG_DebugLighting_61e571d2b9ede1240a524a849d20c997_float(float3 _Base_Color, float3 _NormalWS, float _Metallic, float _Smoothness, float3 _Emission, float _AmbientOcclusion, Bindings_DebugLighting_61e571d2b9ede1240a524a849d20c997_float IN, out float3 BaseColor_1, out float3 Normal_4, out float Metallic_2, out float Smoothness_3, out float3 Emission_5, out float AmbientOcclusion_6)
{
float3 _Property_501515703e3a4a1dbd19f4ae273add46_Out_0_Vector3 = _Base_Color;
float3 _Property_e5bcb5bf3b62412b8983e3aa1ada8fcd_Out_0_Vector3 = _NormalWS;
float3 _Transform_13c6b1e888d440fd8340d4a7138979ba_Out_1_Vector3;
{
float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
_Transform_13c6b1e888d440fd8340d4a7138979ba_Out_1_Vector3 = TransformWorldToTangent(_Property_e5bcb5bf3b62412b8983e3aa1ada8fcd_Out_0_Vector3.xyz, tangentTransform, true);
}
float _Property_7a450453146043b2b11397a72c325042_Out_0_Float = _Metallic;
float _Property_f0326121e031478a90610d60b8321364_Out_0_Float = _Smoothness;
float3 _Property_491d95b34bb245718ee21bff5fc249cd_Out_0_Vector3 = _Emission;
float _Property_da91a6effd53499db08bb774d5686c68_Out_0_Float = _AmbientOcclusion;
float3 _BakedGI_3f01c30cb8b64e9d9f7fbe474622c7dc_Out_1_Vector3 = SHADERGRAPH_BAKED_GI(IN.WorldSpacePosition, _Property_e5bcb5bf3b62412b8983e3aa1ada8fcd_Out_0_Vector3, IN.PixelPosition.xy, IN.uv1.xy, IN.uv2.xy, true);
float3 _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_BaseColorOut_7_Vector3;
float3 _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_NormalOut_11_Vector3;
float _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_MetallicOut_9_Float;
float _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_SmoothnessOut_10_Float;
float3 _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_EmissionOut_12_Vector3;
float _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_AmbientOcclusionOut_13_Float;
SwitchLightingDebug_float(_Property_501515703e3a4a1dbd19f4ae273add46_Out_0_Vector3, _Transform_13c6b1e888d440fd8340d4a7138979ba_Out_1_Vector3, _Property_7a450453146043b2b11397a72c325042_Out_0_Float, _Property_f0326121e031478a90610d60b8321364_Out_0_Float, _Property_491d95b34bb245718ee21bff5fc249cd_Out_0_Vector3, _Property_da91a6effd53499db08bb774d5686c68_Out_0_Float, IN.WorldSpacePosition, _BakedGI_3f01c30cb8b64e9d9f7fbe474622c7dc_Out_1_Vector3, _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_BaseColorOut_7_Vector3, _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_NormalOut_11_Vector3, _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_MetallicOut_9_Float, _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_SmoothnessOut_10_Float, _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_EmissionOut_12_Vector3, _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_AmbientOcclusionOut_13_Float);
BaseColor_1 = _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_BaseColorOut_7_Vector3;
Normal_4 = _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_NormalOut_11_Vector3;
Metallic_2 = _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_MetallicOut_9_Float;
Smoothness_3 = _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_SmoothnessOut_10_Float;
Emission_5 = _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_EmissionOut_12_Vector3;
AmbientOcclusion_6 = _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_AmbientOcclusionOut_13_Float;
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

void Unity_Add_float(float A, float B, out float Out)
{
    Out = A + B;
}

void Unity_Add_half(half A, half B, out half Out)
{
    Out = A + B;
}

void Unity_Reciprocal_float(float In, out float Out)
{
    Out = 1.0/In;
}

void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
{
    Out = pow((1.0 - saturate(dot(normalize(Normal), ViewDir))), Power);
}

void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
{
    Out = lerp(A, B, T);
}

struct Bindings_ReflectanceURP_57a8ea7c8f931c941b2bb57aedc451aa_float
{
float3 WorldSpaceNormal;
float3 WorldSpaceViewDirection;
};

void SG_ReflectanceURP_57a8ea7c8f931c941b2bb57aedc451aa_float(float3 _Base_Color, float3 _NormalWS, bool _NormalWS_3240674a787044a092398b1ca753ad83_IsConnected, float _Metallic, float _Smoothness, float _F0, Bindings_ReflectanceURP_57a8ea7c8f931c941b2bb57aedc451aa_float IN, out float3 Reflectance_1)
{
float _Property_4678b902494b4e1a9b08a8067b7bed85_Out_0_Float = _Smoothness;
float _OneMinus_0aa2823e9b1a4726bd6382418b3e6a87_Out_1_Float;
Unity_OneMinus_float(_Property_4678b902494b4e1a9b08a8067b7bed85_Out_0_Float, _OneMinus_0aa2823e9b1a4726bd6382418b3e6a87_Out_1_Float);
float _Multiply_314f6a0aec0a44538333e69617e91cf9_Out_2_Float;
Unity_Multiply_float_float(_OneMinus_0aa2823e9b1a4726bd6382418b3e6a87_Out_1_Float, _OneMinus_0aa2823e9b1a4726bd6382418b3e6a87_Out_1_Float, _Multiply_314f6a0aec0a44538333e69617e91cf9_Out_2_Float);
float _Add_513724b99c2f4ea2a803e64d80f0c25b_Out_2_Float;
Unity_Add_float(_Multiply_314f6a0aec0a44538333e69617e91cf9_Out_2_Float, float(1), _Add_513724b99c2f4ea2a803e64d80f0c25b_Out_2_Float);
float _Reciprocal_67b338305d0043abb9e7d82dd0f16146_Out_1_Float;
Unity_Reciprocal_float(_Add_513724b99c2f4ea2a803e64d80f0c25b_Out_2_Float, _Reciprocal_67b338305d0043abb9e7d82dd0f16146_Out_1_Float);
float _Property_b67a6773dce34e91ae69bbf282d871cc_Out_0_Float = _F0;
float _Property_703d9ec0a0894a3b965f0ed25a10435b_Out_0_Float = _F0;
float _Add_8ad10875906b4a80872f2b2fb0518183_Out_2_Float;
Unity_Add_float(_Property_4678b902494b4e1a9b08a8067b7bed85_Out_0_Float, _Property_703d9ec0a0894a3b965f0ed25a10435b_Out_0_Float, _Add_8ad10875906b4a80872f2b2fb0518183_Out_2_Float);
float3 _Property_b5d757941bc04f70897cc735055cef09_Out_0_Vector3 = _NormalWS;
bool _Property_b5d757941bc04f70897cc735055cef09_Out_0_Vector3_IsConnected = _NormalWS_3240674a787044a092398b1ca753ad83_IsConnected;
float3 _BranchOnInputConnection_43b8bde55a8a41468ba21d53db128986_Out_3_Vector3 = _Property_b5d757941bc04f70897cc735055cef09_Out_0_Vector3_IsConnected ? _Property_b5d757941bc04f70897cc735055cef09_Out_0_Vector3 : IN.WorldSpaceNormal;
float _FresnelEffect_34b729c62edd4d5f99dc20e2e7d0a7fa_Out_3_Float;
Unity_FresnelEffect_float(_BranchOnInputConnection_43b8bde55a8a41468ba21d53db128986_Out_3_Vector3, IN.WorldSpaceViewDirection, float(4), _FresnelEffect_34b729c62edd4d5f99dc20e2e7d0a7fa_Out_3_Float);
float _Lerp_1cad776e609842c181b8acfaef47c317_Out_3_Float;
Unity_Lerp_float(_Property_b67a6773dce34e91ae69bbf282d871cc_Out_0_Float, _Add_8ad10875906b4a80872f2b2fb0518183_Out_2_Float, _FresnelEffect_34b729c62edd4d5f99dc20e2e7d0a7fa_Out_3_Float, _Lerp_1cad776e609842c181b8acfaef47c317_Out_3_Float);
float _Multiply_0d364d1c231246d981281b868ea74a95_Out_2_Float;
Unity_Multiply_float_float(_Reciprocal_67b338305d0043abb9e7d82dd0f16146_Out_1_Float, _Lerp_1cad776e609842c181b8acfaef47c317_Out_3_Float, _Multiply_0d364d1c231246d981281b868ea74a95_Out_2_Float);
float3 _Property_87ae51a595c24e46ad9ef0f4493231fc_Out_0_Vector3 = _Base_Color;
float _Property_ce0a90815c5046b48dd0564711f2b466_Out_0_Float = _Metallic;
float3 _Lerp_6b4c86a1d5004851a7dba1bacc4fd953_Out_3_Vector3;
Unity_Lerp_float3((_Multiply_0d364d1c231246d981281b868ea74a95_Out_2_Float.xxx), _Property_87ae51a595c24e46ad9ef0f4493231fc_Out_0_Vector3, (_Property_ce0a90815c5046b48dd0564711f2b466_Out_0_Float.xxx), _Lerp_6b4c86a1d5004851a7dba1bacc4fd953_Out_3_Vector3);
Reflectance_1 = _Lerp_6b4c86a1d5004851a7dba1bacc4fd953_Out_3_Vector3;
}

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

void Unity_Multiply_half3_half3(half3 A, half3 B, out half3 Out)
{
Out = A * B;
}

void Unity_Negate_float3(float3 In, out float3 Out)
{
    Out = -1 * In;
}

void Unity_Reflection_float3(float3 In, float3 Normal, out float3 Out)
{
    Out = reflect(In, Normal);
}

// unity-custom-func-begin
void URPReflectionProbe_float(float3 positionWS, float3 reflectVector, float2 normalizedScreenSpaceUV, float roughness, float occlusion, out float3 reflection){
#ifdef SHADERGRAPH_PREVIEW

    reflection = float3(0,0,0);

#else

    reflection = GlossyEnvironmentReflection(reflectVector, positionWS, roughness, occlusion, normalizedScreenSpaceUV);

#endif
}
// unity-custom-func-end

struct Bindings_SampleReflectionProbes_f70e1da6fb6a720439a85a6a2c814a87_float
{
float3 WorldSpaceNormal;
float3 WorldSpaceViewDirection;
float3 WorldSpacePosition;
float2 NDCPosition;
};

void SG_SampleReflectionProbes_f70e1da6fb6a720439a85a6a2c814a87_float(float3 _positionWS, bool _positionWS_d6701bdc1f184a57ac2283491fc460d9_IsConnected, float3 _reflectVector, bool _reflectVector_3e2eb19b69b8469eaf2302c7abc4cbc5_IsConnected, float _smoothness, float _occlusion, Bindings_SampleReflectionProbes_f70e1da6fb6a720439a85a6a2c814a87_float IN, out float3 Out_1)
{
float3 _Property_b993dfa9c8bb4e4ea4f3cb1768e92822_Out_0_Vector3 = _positionWS;
bool _Property_b993dfa9c8bb4e4ea4f3cb1768e92822_Out_0_Vector3_IsConnected = _positionWS_d6701bdc1f184a57ac2283491fc460d9_IsConnected;
float3 _BranchOnInputConnection_8fb583036b0c4313a1ecd93143939f21_Out_3_Vector3 = _Property_b993dfa9c8bb4e4ea4f3cb1768e92822_Out_0_Vector3_IsConnected ? _Property_b993dfa9c8bb4e4ea4f3cb1768e92822_Out_0_Vector3 : IN.WorldSpacePosition;
float3 _Property_27869743c4c14e898d5c15f6fdd4e044_Out_0_Vector3 = _reflectVector;
bool _Property_27869743c4c14e898d5c15f6fdd4e044_Out_0_Vector3_IsConnected = _reflectVector_3e2eb19b69b8469eaf2302c7abc4cbc5_IsConnected;
float3 _Negate_9cf7cea21c5641239fdbcb32480ac39e_Out_1_Vector3;
Unity_Negate_float3(IN.WorldSpaceViewDirection, _Negate_9cf7cea21c5641239fdbcb32480ac39e_Out_1_Vector3);
float3 _Reflection_c8689c494aab4411aadc74299549c6cb_Out_2_Vector3;
Unity_Reflection_float3(_Negate_9cf7cea21c5641239fdbcb32480ac39e_Out_1_Vector3, IN.WorldSpaceNormal, _Reflection_c8689c494aab4411aadc74299549c6cb_Out_2_Vector3);
float3 _BranchOnInputConnection_9600230d09794702a61c1a01f8e842a5_Out_3_Vector3 = _Property_27869743c4c14e898d5c15f6fdd4e044_Out_0_Vector3_IsConnected ? _Property_27869743c4c14e898d5c15f6fdd4e044_Out_0_Vector3 : _Reflection_c8689c494aab4411aadc74299549c6cb_Out_2_Vector3;
float4 _ScreenPosition_270e438746a9466e8aaf01f4903f62fb_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
float _Property_9012e47da801473d8ef85a4092281eb2_Out_0_Float = _smoothness;
float _OneMinus_b2508f25afb44017ba3480edc35cf631_Out_1_Float;
Unity_OneMinus_float(_Property_9012e47da801473d8ef85a4092281eb2_Out_0_Float, _OneMinus_b2508f25afb44017ba3480edc35cf631_Out_1_Float);
float _Property_d602b1723845462cbf00324de1e9e82a_Out_0_Float = _occlusion;
float3 _URPReflectionProbeCustomFunction_7233d098cd214f55baf898d486bfdf4b_reflection_4_Vector3;
URPReflectionProbe_float(_BranchOnInputConnection_8fb583036b0c4313a1ecd93143939f21_Out_3_Vector3, _BranchOnInputConnection_9600230d09794702a61c1a01f8e842a5_Out_3_Vector3, (_ScreenPosition_270e438746a9466e8aaf01f4903f62fb_Out_0_Vector4.xy), _OneMinus_b2508f25afb44017ba3480edc35cf631_Out_1_Float, _Property_d602b1723845462cbf00324de1e9e82a_Out_0_Float, _URPReflectionProbeCustomFunction_7233d098cd214f55baf898d486bfdf4b_reflection_4_Vector3);
Out_1 = _URPReflectionProbeCustomFunction_7233d098cd214f55baf898d486bfdf4b_reflection_4_Vector3;
}

void Unity_Add_float3(float3 A, float3 B, out float3 Out)
{
    Out = A + B;
}

// unity-custom-func-begin
void SSAO_float(float2 normalizedScreenSpaceUV, out float indirectAmbientOcclusion, out float directAmbientOcclusion){
#if defined(_SCREEN_SPACE_OCCLUSION) && !defined(_SURFACE_TYPE_TRANSPARENT) && !defined(SHADERGRAPH_PREVIEW)

    float ssao = saturate(SampleAmbientOcclusion(normalizedScreenSpaceUV) + (1.0 - _AmbientOcclusionParam.x));

    indirectAmbientOcclusion = ssao;

    directAmbientOcclusion = lerp(half(1.0), ssao, _AmbientOcclusionParam.w);

#else

    directAmbientOcclusion = half(1.0);

    indirectAmbientOcclusion = half(1.0);

#endif
}
// unity-custom-func-end

struct Bindings_ScreenSpaceAmbientOcclusion_616a08cdf385c2d4997a5ed9d01e16a8_float
{
float2 NDCPosition;
};

void SG_ScreenSpaceAmbientOcclusion_616a08cdf385c2d4997a5ed9d01e16a8_float(Bindings_ScreenSpaceAmbientOcclusion_616a08cdf385c2d4997a5ed9d01e16a8_float IN, out float indirectAO_1, out float directAO_2)
{
float4 _ScreenPosition_0fdc511287e14fd48ca909caba575383_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
float _SSAOCustomFunction_0f48e52099d04b51a6b1dc52cce50d39_indirectAmbientOcclusion_0_Float;
float _SSAOCustomFunction_0f48e52099d04b51a6b1dc52cce50d39_directAmbientOcclusion_1_Float;
SSAO_float((_ScreenPosition_0fdc511287e14fd48ca909caba575383_Out_0_Vector4.xy), _SSAOCustomFunction_0f48e52099d04b51a6b1dc52cce50d39_indirectAmbientOcclusion_0_Float, _SSAOCustomFunction_0f48e52099d04b51a6b1dc52cce50d39_directAmbientOcclusion_1_Float);
indirectAO_1 = _SSAOCustomFunction_0f48e52099d04b51a6b1dc52cce50d39_indirectAmbientOcclusion_0_Float;
directAO_2 = _SSAOCustomFunction_0f48e52099d04b51a6b1dc52cce50d39_directAmbientOcclusion_1_Float;
}

void Unity_Minimum_float(float A, float B, out float Out)
{
    Out = min(A, B);
};

struct Bindings_AmbientURP_300875fdd653fe340b08ad1547984cf1_float
{
float3 WorldSpaceNormal;
float3 WorldSpaceViewDirection;
float3 WorldSpacePosition;
float2 NDCPosition;
float2 PixelPosition;
half4 uv1;
half4 uv2;
};

void SG_AmbientURP_300875fdd653fe340b08ad1547984cf1_float(float3 _Base_Color, float3 _NormalWS, bool _NormalWS_3a565a44841d4b729f8e86b08d09299c_IsConnected, float _Metallic, float _Smoothness, float3 _Reflectance, float _Ambient_Occlusion, Bindings_AmbientURP_300875fdd653fe340b08ad1547984cf1_float IN, out float3 Ambient_1, out float DirectAO_2)
{
float3 _Property_d72d925c86ff4010a968b702f0972f69_Out_0_Vector3 = _NormalWS;
bool _Property_d72d925c86ff4010a968b702f0972f69_Out_0_Vector3_IsConnected = _NormalWS_3a565a44841d4b729f8e86b08d09299c_IsConnected;
float3 _BranchOnInputConnection_5e35c0fc2eee4cf7ae47da45409fa2a7_Out_3_Vector3 = _Property_d72d925c86ff4010a968b702f0972f69_Out_0_Vector3_IsConnected ? _Property_d72d925c86ff4010a968b702f0972f69_Out_0_Vector3 : IN.WorldSpaceNormal;
float3 _BakedGI_1ac35076ff2349f99fec2cef2550ff2d_Out_1_Vector3 = SHADERGRAPH_BAKED_GI(IN.WorldSpacePosition, _BranchOnInputConnection_5e35c0fc2eee4cf7ae47da45409fa2a7_Out_3_Vector3, IN.PixelPosition.xy, IN.uv1.xy, IN.uv2.xy, true);
float3 _Property_5fb17e215f49424cb9cc9d0806f3f47d_Out_0_Vector3 = _Base_Color;
float _Property_f995d8544fdb448d85ac845c7bdee967_Out_0_Float = _Metallic;
float3 _Lerp_842ba4fcd0cf48a3afa108eecd7d56a8_Out_3_Vector3;
Unity_Lerp_float3(_Property_5fb17e215f49424cb9cc9d0806f3f47d_Out_0_Vector3, float3(0, 0, 0), (_Property_f995d8544fdb448d85ac845c7bdee967_Out_0_Float.xxx), _Lerp_842ba4fcd0cf48a3afa108eecd7d56a8_Out_3_Vector3);
float3 _Multiply_48ca9faac6354eefabc65eeb591f3fc4_Out_2_Vector3;
Unity_Multiply_float3_float3(_BakedGI_1ac35076ff2349f99fec2cef2550ff2d_Out_1_Vector3, _Lerp_842ba4fcd0cf48a3afa108eecd7d56a8_Out_3_Vector3, _Multiply_48ca9faac6354eefabc65eeb591f3fc4_Out_2_Vector3);
float3 _Negate_4f98a1dfbc4d4bd1abe58f406453303f_Out_1_Vector3;
Unity_Negate_float3(IN.WorldSpaceViewDirection, _Negate_4f98a1dfbc4d4bd1abe58f406453303f_Out_1_Vector3);
float3 _Reflection_710a69cb22b745929e6bb9b84d11de2f_Out_2_Vector3;
Unity_Reflection_float3(_Negate_4f98a1dfbc4d4bd1abe58f406453303f_Out_1_Vector3, _BranchOnInputConnection_5e35c0fc2eee4cf7ae47da45409fa2a7_Out_3_Vector3, _Reflection_710a69cb22b745929e6bb9b84d11de2f_Out_2_Vector3);
float _Property_8c3e921b9cb34f7b82d2a71254653c09_Out_0_Float = _Smoothness;
Bindings_SampleReflectionProbes_f70e1da6fb6a720439a85a6a2c814a87_float _SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08;
_SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08.WorldSpaceNormal = IN.WorldSpaceNormal;
_SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
_SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08.WorldSpacePosition = IN.WorldSpacePosition;
_SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08.NDCPosition = IN.NDCPosition;
float3 _SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08_Out_1_Vector3;
SG_SampleReflectionProbes_f70e1da6fb6a720439a85a6a2c814a87_float(half3 (0, 0, 0), false, _Reflection_710a69cb22b745929e6bb9b84d11de2f_Out_2_Vector3, true, _Property_8c3e921b9cb34f7b82d2a71254653c09_Out_0_Float, half(1), _SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08, _SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08_Out_1_Vector3);
float3 _Property_2ddaa58bd1e94d0b8508ce91ad39fa39_Out_0_Vector3 = _Reflectance;
float3 _Multiply_40be6c08ca2f44ef99b6a2b81955d62c_Out_2_Vector3;
Unity_Multiply_float3_float3(_SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08_Out_1_Vector3, _Property_2ddaa58bd1e94d0b8508ce91ad39fa39_Out_0_Vector3, _Multiply_40be6c08ca2f44ef99b6a2b81955d62c_Out_2_Vector3);
float3 _Add_c0a57a54eb8b4419a7e907a65e6556a7_Out_2_Vector3;
Unity_Add_float3(_Multiply_48ca9faac6354eefabc65eeb591f3fc4_Out_2_Vector3, _Multiply_40be6c08ca2f44ef99b6a2b81955d62c_Out_2_Vector3, _Add_c0a57a54eb8b4419a7e907a65e6556a7_Out_2_Vector3);
float _Property_5a996c5d941d46019b3ac5ada526c475_Out_0_Float = _Ambient_Occlusion;
Bindings_ScreenSpaceAmbientOcclusion_616a08cdf385c2d4997a5ed9d01e16a8_float _ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e;
_ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e.NDCPosition = IN.NDCPosition;
half _ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e_indirectAO_1_Float;
half _ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e_directAO_2_Float;
SG_ScreenSpaceAmbientOcclusion_616a08cdf385c2d4997a5ed9d01e16a8_float(_ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e, _ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e_indirectAO_1_Float, _ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e_directAO_2_Float);
float _Minimum_699e1643e9974baa97f6f21c8f949d09_Out_2_Float;
Unity_Minimum_float(_Property_5a996c5d941d46019b3ac5ada526c475_Out_0_Float, _ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e_indirectAO_1_Float, _Minimum_699e1643e9974baa97f6f21c8f949d09_Out_2_Float);
float3 _Multiply_ccaf4dfa5cdb4d9fae7fd92dc7d512da_Out_2_Vector3;
Unity_Multiply_float3_float3(_Add_c0a57a54eb8b4419a7e907a65e6556a7_Out_2_Vector3, (_Minimum_699e1643e9974baa97f6f21c8f949d09_Out_2_Float.xxx), _Multiply_ccaf4dfa5cdb4d9fae7fd92dc7d512da_Out_2_Vector3);
float _Minimum_c4dcab6b18b34dde987e68f86d22aed7_Out_2_Float;
Unity_Minimum_float(_Property_5a996c5d941d46019b3ac5ada526c475_Out_0_Float, _ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e_directAO_2_Float, _Minimum_c4dcab6b18b34dde987e68f86d22aed7_Out_2_Float);
Ambient_1 = _Multiply_ccaf4dfa5cdb4d9fae7fd92dc7d512da_Out_2_Vector3;
DirectAO_2 = _Minimum_c4dcab6b18b34dde987e68f86d22aed7_Out_2_Float;
}

// unity-custom-func-begin
void GetMainLightData_float(float3 worldPos, out float3 direction, out float3 color, out float shadowAtten){
#ifdef SHADERGRAPH_PREVIEW
    direction = normalize(float3(-0.7,0.7,-0.7));
    color = float3(1,1,1);
    shadowAtten = 1;
#else
    #if defined(UNIVERSAL_PIPELINE_CORE_INCLUDED)
        float4 shadowCoord = TransformWorldToShadowCoord(worldPos);
        Light mainLight = GetMainLight(shadowCoord);
        direction = mainLight.direction;
        color = mainLight.color;
        shadowAtten = mainLight.shadowAttenuation;
    #else
        direction = normalize(float3(-0.7, 0.7, -0.7));
        color = float3(1, 1, 1);
        shadowAtten = 0;
    #endif
#endif
}
// unity-custom-func-end

// unity-custom-func-begin
void GetMainLightData_half(half3 worldPos, out half3 direction, out half3 color, out half shadowAtten){
#ifdef SHADERGRAPH_PREVIEW
    direction = normalize(float3(-0.7,0.7,-0.7));
    color = float3(1,1,1);
    shadowAtten = 1;
#else
    #if defined(UNIVERSAL_PIPELINE_CORE_INCLUDED)
        float4 shadowCoord = TransformWorldToShadowCoord(worldPos);
        Light mainLight = GetMainLight(shadowCoord);
        direction = mainLight.direction;
        color = mainLight.color;
        shadowAtten = mainLight.shadowAttenuation;
    #else
        direction = normalize(float3(-0.7, 0.7, -0.7));
        color = float3(1, 1, 1);
        shadowAtten = 0;
    #endif
#endif
}
// unity-custom-func-end

struct Bindings_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float
{
float3 AbsoluteWorldSpacePosition;
};

void SG_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float(Bindings_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float IN, out float3 Direction_1, out float3 Color_2, out float ShadowAtten_3)
{
float3 _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_direction_2_Vector3;
float3 _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_color_3_Vector3;
float _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_shadowAtten_5_Float;
GetMainLightData_float(IN.AbsoluteWorldSpacePosition, _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_direction_2_Vector3, _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_color_3_Vector3, _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_shadowAtten_5_Float);
Direction_1 = _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_direction_2_Vector3;
Color_2 = _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_color_3_Vector3;
ShadowAtten_3 = _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_shadowAtten_5_Float;
}

struct Bindings_MainLight_f97aba6a33b86e5498cdd202ba0c9313_half
{
float3 AbsoluteWorldSpacePosition;
};

void SG_MainLight_f97aba6a33b86e5498cdd202ba0c9313_half(Bindings_MainLight_f97aba6a33b86e5498cdd202ba0c9313_half IN, out half3 Direction_1, out half3 Color_2, out half ShadowAtten_3)
{
half3 _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_direction_2_Vector3;
half3 _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_color_3_Vector3;
half _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_shadowAtten_5_Float;
GetMainLightData_half(IN.AbsoluteWorldSpacePosition, _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_direction_2_Vector3, _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_color_3_Vector3, _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_shadowAtten_5_Float);
Direction_1 = _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_direction_2_Vector3;
Color_2 = _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_color_3_Vector3;
ShadowAtten_3 = _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_shadowAtten_5_Float;
}

void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
{
    Out = dot(A, B);
}

void Unity_DotProduct_half3(half3 A, half3 B, out half Out)
{
    Out = dot(A, B);
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Saturate_half(half In, out half Out)
{
    Out = saturate(In);
}

struct Bindings_DiffuseLambert_cb5cb9cef826e9f448011787f0d627b2_half
{
float3 WorldSpaceNormal;
float3 AbsoluteWorldSpacePosition;
};

void SG_DiffuseLambert_cb5cb9cef826e9f448011787f0d627b2_half(half3 _NormalWS, bool _NormalWS_68a7999ae9ea4bfba3702fd95b0d1a14_IsConnected, half3 _LightVector, bool _LightVector_a12354c78b694cc6b2bdddd67d09ccdc_IsConnected, Bindings_DiffuseLambert_cb5cb9cef826e9f448011787f0d627b2_half IN, out half Diffuse_1)
{
half3 _Property_c979bfc9e06b459ca5e503658f2eda27_Out_0_Vector3 = _NormalWS;
bool _Property_c979bfc9e06b459ca5e503658f2eda27_Out_0_Vector3_IsConnected = _NormalWS_68a7999ae9ea4bfba3702fd95b0d1a14_IsConnected;
half3 _BranchOnInputConnection_71cde5ac4ee04aacb1e2544c8017ba47_Out_3_Vector3 = _Property_c979bfc9e06b459ca5e503658f2eda27_Out_0_Vector3_IsConnected ? _Property_c979bfc9e06b459ca5e503658f2eda27_Out_0_Vector3 : IN.WorldSpaceNormal;
half3 _Property_99ccf4aecf59420794efa0951355f7ab_Out_0_Vector3 = _LightVector;
bool _Property_99ccf4aecf59420794efa0951355f7ab_Out_0_Vector3_IsConnected = _LightVector_a12354c78b694cc6b2bdddd67d09ccdc_IsConnected;
Bindings_MainLight_f97aba6a33b86e5498cdd202ba0c9313_half _MainLight_fa0151c045984bcab58e58725bae0709;
_MainLight_fa0151c045984bcab58e58725bae0709.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
half3 _MainLight_fa0151c045984bcab58e58725bae0709_Direction_1_Vector3;
half3 _MainLight_fa0151c045984bcab58e58725bae0709_Color_2_Vector3;
half _MainLight_fa0151c045984bcab58e58725bae0709_ShadowAtten_3_Float;
SG_MainLight_f97aba6a33b86e5498cdd202ba0c9313_half(_MainLight_fa0151c045984bcab58e58725bae0709, _MainLight_fa0151c045984bcab58e58725bae0709_Direction_1_Vector3, _MainLight_fa0151c045984bcab58e58725bae0709_Color_2_Vector3, _MainLight_fa0151c045984bcab58e58725bae0709_ShadowAtten_3_Float);
half3 _BranchOnInputConnection_d18845e766084954af1aa554531c90b9_Out_3_Vector3 = _Property_99ccf4aecf59420794efa0951355f7ab_Out_0_Vector3_IsConnected ? _Property_99ccf4aecf59420794efa0951355f7ab_Out_0_Vector3 : _MainLight_fa0151c045984bcab58e58725bae0709_Direction_1_Vector3;
half _DotProduct_daa979e4f9384944a14a23e079be6a5c_Out_2_Float;
Unity_DotProduct_half3(_BranchOnInputConnection_71cde5ac4ee04aacb1e2544c8017ba47_Out_3_Vector3, _BranchOnInputConnection_d18845e766084954af1aa554531c90b9_Out_3_Vector3, _DotProduct_daa979e4f9384944a14a23e079be6a5c_Out_2_Float);
half _Saturate_4747439b9bfa431293a93646ce71aa12_Out_1_Float;
Unity_Saturate_half(_DotProduct_daa979e4f9384944a14a23e079be6a5c_Out_2_Float, _Saturate_4747439b9bfa431293a93646ce71aa12_Out_1_Float);
Diffuse_1 = _Saturate_4747439b9bfa431293a93646ce71aa12_Out_1_Float;
}

void Unity_Clamp_float(float In, float Min, float Max, out float Out)
{
    Out = clamp(In, Min, Max);
}

void Unity_Normalize_float3(float3 In, out float3 Out)
{
    Out = normalize(In);
}

struct Bindings_HalfAngle_e6f25cf5cc5b2cc4da597068c1610d98_float
{
};

void SG_HalfAngle_e6f25cf5cc5b2cc4da597068c1610d98_float(float3 _viewDir, float3 _lightDir, Bindings_HalfAngle_e6f25cf5cc5b2cc4da597068c1610d98_float IN, out float3 Out_1)
{
float3 _Property_fde52ad74bda46adabbcc34b42b16131_Out_0_Vector3 = _viewDir;
float3 _Property_1dc55a6640574aaf8c04290eb0d5e816_Out_0_Vector3 = _lightDir;
float3 _Add_2a8cf5c52e8c4e3fb8c3f9a87b68b2a2_Out_2_Vector3;
Unity_Add_float3(_Property_fde52ad74bda46adabbcc34b42b16131_Out_0_Vector3, _Property_1dc55a6640574aaf8c04290eb0d5e816_Out_0_Vector3, _Add_2a8cf5c52e8c4e3fb8c3f9a87b68b2a2_Out_2_Vector3);
float3 _Normalize_b3b8196f46224ae3a998bba24956de7f_Out_1_Vector3;
Unity_Normalize_float3(_Add_2a8cf5c52e8c4e3fb8c3f9a87b68b2a2_Out_2_Vector3, _Normalize_b3b8196f46224ae3a998bba24956de7f_Out_1_Vector3);
Out_1 = _Normalize_b3b8196f46224ae3a998bba24956de7f_Out_1_Vector3;
}

void Unity_Subtract_float(float A, float B, out float Out)
{
    Out = A - B;
}

void Unity_Subtract_half(half A, half B, out half Out)
{
    Out = A - B;
}

void Unity_Maximum_float(float A, float B, out float Out)
{
    Out = max(A, B);
}

void Unity_Maximum_half(half A, half B, out half Out)
{
    Out = max(A, B);
}

// unity-custom-func-begin
void ClampHalf_half(half In, out half Out){
// On platforms where half actually means something, the denominator has a risk of overflow
// clamp below was added specifically to "fix" that, but dx compiler (we convert bytecode to metal/gles)
// sees that specularTerm have only non-negative terms, so it skips max(0,..) in clamp (leaving only min(100,...))

Out = In;
#if REAL_IS_HALF
	Out = Out - HALF_MIN;
	Out = clamp(Out, 0.0, 1000.0);// Prevent FP16 overflow on mobiles
#endif
}
// unity-custom-func-end

struct Bindings_SpecularURP_836ccbead8eba604dae19317e6fd4f6f_half
{
float3 WorldSpaceNormal;
float3 WorldSpaceViewDirection;
float3 AbsoluteWorldSpacePosition;
};

void SG_SpecularURP_836ccbead8eba604dae19317e6fd4f6f_half(float3 _NormalWS, bool _NormalWS_5a3c9a3a7faa491894a42d170b5bfeb5_IsConnected, half _Smoothness, half3 _Reflectance, float3 _LightVector, bool _LightVector_3db37b6247094f32bcccc4cb689d525f_IsConnected, Bindings_SpecularURP_836ccbead8eba604dae19317e6fd4f6f_half IN, out half3 Specular_1)
{
half _Property_65663a4adb9d4d15a53c703bd776ed76_Out_0_Float = _Smoothness;
half _OneMinus_6b5b83d6bb3448b4a48ff714eae900b8_Out_1_Float;
Unity_OneMinus_half(_Property_65663a4adb9d4d15a53c703bd776ed76_Out_0_Float, _OneMinus_6b5b83d6bb3448b4a48ff714eae900b8_Out_1_Float);
half _Multiply_0d498c303fa747ca821fcfd6d09f0cac_Out_2_Float;
Unity_Multiply_half_half(_OneMinus_6b5b83d6bb3448b4a48ff714eae900b8_Out_1_Float, _OneMinus_6b5b83d6bb3448b4a48ff714eae900b8_Out_1_Float, _Multiply_0d498c303fa747ca821fcfd6d09f0cac_Out_2_Float);
half _Multiply_58dcb1541dc645ee91419691340a6e24_Out_2_Float;
Unity_Multiply_half_half(_Multiply_0d498c303fa747ca821fcfd6d09f0cac_Out_2_Float, _Multiply_0d498c303fa747ca821fcfd6d09f0cac_Out_2_Float, _Multiply_58dcb1541dc645ee91419691340a6e24_Out_2_Float);
float3 _Property_031663d8c32f41ec8c5aa64dfd664823_Out_0_Vector3 = _LightVector;
bool _Property_031663d8c32f41ec8c5aa64dfd664823_Out_0_Vector3_IsConnected = _LightVector_3db37b6247094f32bcccc4cb689d525f_IsConnected;
Bindings_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float _MainLight_6570bf88718b46ebb6bd80eec408287a;
_MainLight_6570bf88718b46ebb6bd80eec408287a.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
float3 _MainLight_6570bf88718b46ebb6bd80eec408287a_Direction_1_Vector3;
float3 _MainLight_6570bf88718b46ebb6bd80eec408287a_Color_2_Vector3;
float _MainLight_6570bf88718b46ebb6bd80eec408287a_ShadowAtten_3_Float;
SG_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float(_MainLight_6570bf88718b46ebb6bd80eec408287a, _MainLight_6570bf88718b46ebb6bd80eec408287a_Direction_1_Vector3, _MainLight_6570bf88718b46ebb6bd80eec408287a_Color_2_Vector3, _MainLight_6570bf88718b46ebb6bd80eec408287a_ShadowAtten_3_Float);
float3 _BranchOnInputConnection_6a7b13b3cb82474aa187229c3d17a00f_Out_3_Vector3 = _Property_031663d8c32f41ec8c5aa64dfd664823_Out_0_Vector3_IsConnected ? _Property_031663d8c32f41ec8c5aa64dfd664823_Out_0_Vector3 : _MainLight_6570bf88718b46ebb6bd80eec408287a_Direction_1_Vector3;
Bindings_HalfAngle_e6f25cf5cc5b2cc4da597068c1610d98_float _HalfAngle_f48886360d2649d8b7540e6fb3eef669;
float3 _HalfAngle_f48886360d2649d8b7540e6fb3eef669_Out_1_Vector3;
SG_HalfAngle_e6f25cf5cc5b2cc4da597068c1610d98_float(IN.WorldSpaceViewDirection, _BranchOnInputConnection_6a7b13b3cb82474aa187229c3d17a00f_Out_3_Vector3, _HalfAngle_f48886360d2649d8b7540e6fb3eef669, _HalfAngle_f48886360d2649d8b7540e6fb3eef669_Out_1_Vector3);
float3 _Property_801dfbee5fa540ac80af739a98535520_Out_0_Vector3 = _NormalWS;
bool _Property_801dfbee5fa540ac80af739a98535520_Out_0_Vector3_IsConnected = _NormalWS_5a3c9a3a7faa491894a42d170b5bfeb5_IsConnected;
float3 _BranchOnInputConnection_72430741d0e04d2dbf5368b624a090cc_Out_3_Vector3 = _Property_801dfbee5fa540ac80af739a98535520_Out_0_Vector3_IsConnected ? _Property_801dfbee5fa540ac80af739a98535520_Out_0_Vector3 : IN.WorldSpaceNormal;
float _DotProduct_4558c6edcb084d359ac8ee4b2934ea05_Out_2_Float;
Unity_DotProduct_float3(_HalfAngle_f48886360d2649d8b7540e6fb3eef669_Out_1_Vector3, _BranchOnInputConnection_72430741d0e04d2dbf5368b624a090cc_Out_3_Vector3, _DotProduct_4558c6edcb084d359ac8ee4b2934ea05_Out_2_Float);
float _Saturate_23d3962f416c4150a990dcb36b5ecbc4_Out_1_Float;
Unity_Saturate_float(_DotProduct_4558c6edcb084d359ac8ee4b2934ea05_Out_2_Float, _Saturate_23d3962f416c4150a990dcb36b5ecbc4_Out_1_Float);
float _Multiply_0c95bad7699b4ca9a8ce1e6744a02f14_Out_2_Float;
Unity_Multiply_float_float(_Saturate_23d3962f416c4150a990dcb36b5ecbc4_Out_1_Float, _Saturate_23d3962f416c4150a990dcb36b5ecbc4_Out_1_Float, _Multiply_0c95bad7699b4ca9a8ce1e6744a02f14_Out_2_Float);
half _Subtract_c6521ef2abfd4cb6b19d856f80ce6635_Out_2_Float;
Unity_Subtract_half(_Multiply_58dcb1541dc645ee91419691340a6e24_Out_2_Float, half(1), _Subtract_c6521ef2abfd4cb6b19d856f80ce6635_Out_2_Float);
float _Multiply_428fcfebb99e43a2846be57068218dd1_Out_2_Float;
Unity_Multiply_float_float(_Multiply_0c95bad7699b4ca9a8ce1e6744a02f14_Out_2_Float, _Subtract_c6521ef2abfd4cb6b19d856f80ce6635_Out_2_Float, _Multiply_428fcfebb99e43a2846be57068218dd1_Out_2_Float);
float _Add_0670771ec2f54d57ab3ba72f8cf8563e_Out_2_Float;
Unity_Add_float(_Multiply_428fcfebb99e43a2846be57068218dd1_Out_2_Float, float(1.00001), _Add_0670771ec2f54d57ab3ba72f8cf8563e_Out_2_Float);
half _Multiply_6de38edabacc4727a961face8b45eec7_Out_2_Float;
Unity_Multiply_half_half(_Add_0670771ec2f54d57ab3ba72f8cf8563e_Out_2_Float, _Add_0670771ec2f54d57ab3ba72f8cf8563e_Out_2_Float, _Multiply_6de38edabacc4727a961face8b45eec7_Out_2_Float);
half _DotProduct_f2e2c0a55fa749c6bcac3befdaf5cc9e_Out_2_Float;
Unity_DotProduct_half3(_HalfAngle_f48886360d2649d8b7540e6fb3eef669_Out_1_Vector3, _MainLight_6570bf88718b46ebb6bd80eec408287a_Direction_1_Vector3, _DotProduct_f2e2c0a55fa749c6bcac3befdaf5cc9e_Out_2_Float);
half _Saturate_b1a77817dddf4a70af2dbe91af25aa03_Out_1_Float;
Unity_Saturate_half(_DotProduct_f2e2c0a55fa749c6bcac3befdaf5cc9e_Out_2_Float, _Saturate_b1a77817dddf4a70af2dbe91af25aa03_Out_1_Float);
half _Multiply_d16da90e46294009bbf058077207a283_Out_2_Float;
Unity_Multiply_half_half(_Saturate_b1a77817dddf4a70af2dbe91af25aa03_Out_1_Float, _Saturate_b1a77817dddf4a70af2dbe91af25aa03_Out_1_Float, _Multiply_d16da90e46294009bbf058077207a283_Out_2_Float);
half _Maximum_d4132949baac4389abbeb7cf75a9450d_Out_2_Float;
Unity_Maximum_half(half(0.1), _Multiply_d16da90e46294009bbf058077207a283_Out_2_Float, _Maximum_d4132949baac4389abbeb7cf75a9450d_Out_2_Float);
half _Multiply_fd05dbe22b3b449c83455ee11e655ceb_Out_2_Float;
Unity_Multiply_half_half(_Multiply_6de38edabacc4727a961face8b45eec7_Out_2_Float, _Maximum_d4132949baac4389abbeb7cf75a9450d_Out_2_Float, _Multiply_fd05dbe22b3b449c83455ee11e655ceb_Out_2_Float);
half _Multiply_93304cb0ca10459185664116606ab5f3_Out_2_Float;
Unity_Multiply_half_half(_Multiply_0d498c303fa747ca821fcfd6d09f0cac_Out_2_Float, 4, _Multiply_93304cb0ca10459185664116606ab5f3_Out_2_Float);
half _Add_f5a8f83262b84718853bbbadf886aa8d_Out_2_Float;
Unity_Add_half(_Multiply_93304cb0ca10459185664116606ab5f3_Out_2_Float, half(2), _Add_f5a8f83262b84718853bbbadf886aa8d_Out_2_Float);
half _Multiply_ceffc5e723e346189be38ea16239f587_Out_2_Float;
Unity_Multiply_half_half(_Multiply_fd05dbe22b3b449c83455ee11e655ceb_Out_2_Float, _Add_f5a8f83262b84718853bbbadf886aa8d_Out_2_Float, _Multiply_ceffc5e723e346189be38ea16239f587_Out_2_Float);
half _Divide_2589d64ba94841aa933a4e5af66460cf_Out_2_Float;
Unity_Divide_half(_Multiply_58dcb1541dc645ee91419691340a6e24_Out_2_Float, _Multiply_ceffc5e723e346189be38ea16239f587_Out_2_Float, _Divide_2589d64ba94841aa933a4e5af66460cf_Out_2_Float);
half _ClampHalfCustomFunction_ff6472ae9f514325a4b9e1f9a0f7a70f_Out_1_Float;
ClampHalf_half(_Divide_2589d64ba94841aa933a4e5af66460cf_Out_2_Float, _ClampHalfCustomFunction_ff6472ae9f514325a4b9e1f9a0f7a70f_Out_1_Float);
half3 _Property_a62a42c671e64b02b9f980de350ccbd3_Out_0_Vector3 = _Reflectance;
half3 _Multiply_db0b4127db554affba0f41edae5085ce_Out_2_Vector3;
Unity_Multiply_half3_half3((_ClampHalfCustomFunction_ff6472ae9f514325a4b9e1f9a0f7a70f_Out_1_Float.xxx), _Property_a62a42c671e64b02b9f980de350ccbd3_Out_0_Vector3, _Multiply_db0b4127db554affba0f41edae5085ce_Out_2_Vector3);
Specular_1 = _Multiply_db0b4127db554affba0f41edae5085ce_Out_2_Vector3;
}

// unity-custom-func-begin
void AddAdditionalLights_float(float Smoothness, float3 WorldPosition, float3 WorldNormal, float3 WorldView, float MainDiffuse, float3 MainSpecular, float3 MainColor, float3 Reflectance, float2 ScreenPosition, out float Diffuse, out float3 Specular, out float3 Color){
Diffuse = MainDiffuse;

Specular = MainSpecular;

Color = MainColor * (MainDiffuse + MainSpecular);



#ifndef SHADERGRAPH_PREVIEW

    

    uint pixelLightCount = GetAdditionalLightsCount();

    half Roughness = pow(1 - Smoothness, 2);

    half Roughness2 = Roughness * Roughness;

	half Roughness2Minus1 = Roughness2 - 1;

	half normalizationTerm = (Roughness * half(4.0) + half(2.0));



#if USE_CLUSTER_LIGHT_LOOP

    // for Foward+ LIGHT_LOOP_BEGIN macro uses inputData.normalizedScreenSpaceUV and inputData.positionWS

    InputData inputData = (InputData)0;



    inputData.normalizedScreenSpaceUV = ScreenPosition;

    inputData.positionWS = WorldPosition;

#endif



    LIGHT_LOOP_BEGIN(pixelLightCount)

		// Call the URP additional light algorithm. This will not calculate shadows, since we don't pass a shadow mask value

		Light light = GetAdditionalLight(lightIndex, WorldPosition);

		// Manually set the shadow attenuation by calculating realtime shadows

		light.shadowAttenuation = AdditionalLightRealtimeShadow(lightIndex, WorldPosition, light.direction);

        #if defined(_LIGHT_COOKIES)

            float3 cookieColor = SampleAdditionalLightCookie(lightIndex, WorldPosition);

            light.color *= cookieColor;

        #endif

        float NdotL = saturate(dot(WorldNormal, light.direction));

        float atten = light.distanceAttenuation * light.shadowAttenuation;

        float thisDiffuse = NdotL * atten;

        //DirectBRDFSpecular



        float3 lightDirectionWSFloat3 = float3(light.direction);

        float3 halfDir = SafeNormalize(lightDirectionWSFloat3 + float3(WorldView));

        float NoH = saturate(dot(float3(WorldNormal), halfDir));

        half LoH = half(saturate(dot(lightDirectionWSFloat3, halfDir)));

        float d = NoH * NoH * Roughness2Minus1 + 1.00001f;

        half LoH2 = LoH * LoH;

        half spec = Roughness2 / ((d * d) * max(0.1h, LoH2) * normalizationTerm);

        #if REAL_IS_HALF

            spec = spec - HALF_MIN;

            spec = clamp(spec, 0.0, 1000.0);

        #endif		

        float3 thisSpecular = spec * Reflectance * NdotL * atten;



        Diffuse += thisDiffuse;

        Specular += thisSpecular;



        Color += light.color * (thisDiffuse + thisSpecular);

    LIGHT_LOOP_END

    float total = Diffuse + dot(Specular, float3(0.333, 0.333, 0.333));

    Color = total <= 0 ? MainColor : Color / total;

#endif
}
// unity-custom-func-end

struct Bindings_AdditionalLightsURP_97b36dcc0c1df064bab3b4b47d231089_float
{
float3 WorldSpaceNormal;
float3 WorldSpaceViewDirection;
float3 AbsoluteWorldSpacePosition;
float2 NDCPosition;
};

void SG_AdditionalLightsURP_97b36dcc0c1df064bab3b4b47d231089_float(float _MainLightDiffuse, float3 _MainLightSpecular, float3 _MainLightColor, float3 _NormalWS, bool _NormalWS_70cbf5ac6da04bf6bd87eb71ccb7c48d_IsConnected, float _Smoothness, float3 _Reflectance, Bindings_AdditionalLightsURP_97b36dcc0c1df064bab3b4b47d231089_float IN, out float Diffuse_1, out float3 Specular_2, out float3 Color_3)
{
float _Property_b9f05025da4f4857a7b1b6f56259a629_Out_0_Float = _Smoothness;
float3 _Property_3e48999a139848e6ab2e955c61810b83_Out_0_Vector3 = _NormalWS;
bool _Property_3e48999a139848e6ab2e955c61810b83_Out_0_Vector3_IsConnected = _NormalWS_70cbf5ac6da04bf6bd87eb71ccb7c48d_IsConnected;
float3 _BranchOnInputConnection_d869e3d8654b48a491de945ad8af6301_Out_3_Vector3 = _Property_3e48999a139848e6ab2e955c61810b83_Out_0_Vector3_IsConnected ? _Property_3e48999a139848e6ab2e955c61810b83_Out_0_Vector3 : IN.WorldSpaceNormal;
float _Property_25880f0697234954b8dc6ef11af3752d_Out_0_Float = _MainLightDiffuse;
float3 _Property_1e29ad89226c4d84a936fe7530839aef_Out_0_Vector3 = _MainLightSpecular;
float3 _Property_ac790fc8215b4b3d8851855d2153960d_Out_0_Vector3 = _MainLightColor;
float3 _Property_eea8eda455d44ae7b30c65f80baac806_Out_0_Vector3 = _Reflectance;
float4 _ScreenPosition_c15512235d2f46b4b03bc2c4a1be229d_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
float _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Diffuse_7_Float;
float3 _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Specular_8_Vector3;
float3 _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Color_9_Vector3;
AddAdditionalLights_float(_Property_b9f05025da4f4857a7b1b6f56259a629_Out_0_Float, IN.AbsoluteWorldSpacePosition, _BranchOnInputConnection_d869e3d8654b48a491de945ad8af6301_Out_3_Vector3, IN.WorldSpaceViewDirection, _Property_25880f0697234954b8dc6ef11af3752d_Out_0_Float, _Property_1e29ad89226c4d84a936fe7530839aef_Out_0_Vector3, _Property_ac790fc8215b4b3d8851855d2153960d_Out_0_Vector3, _Property_eea8eda455d44ae7b30c65f80baac806_Out_0_Vector3, (_ScreenPosition_c15512235d2f46b4b03bc2c4a1be229d_Out_0_Vector4.xy), _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Diffuse_7_Float, _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Specular_8_Vector3, _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Color_9_Vector3);
Diffuse_1 = _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Diffuse_7_Float;
Specular_2 = _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Specular_8_Vector3;
Color_3 = _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Color_9_Vector3;
}

void Unity_Fog_float(out float4 Color, out float Density, float3 Position)
{
    SHADERGRAPH_FOG(Position, Color, Density);
}

struct Bindings_Fog_286ae83400099a24bba6faf005588be7_float
{
float3 ObjectSpacePosition;
};

void SG_Fog_286ae83400099a24bba6faf005588be7_float(float3 _In, Bindings_Fog_286ae83400099a24bba6faf005588be7_float IN, out float3 Out_1)
{
float3 _Property_626923dc627443639da97776de7dcc22_Out_0_Vector3 = _In;
float4 _Fog_acabe3c84c9549f3880ce7d106150576_Color_0_Vector4;
float _Fog_acabe3c84c9549f3880ce7d106150576_Density_1_Float;
Unity_Fog_float(_Fog_acabe3c84c9549f3880ce7d106150576_Color_0_Vector4, _Fog_acabe3c84c9549f3880ce7d106150576_Density_1_Float, IN.ObjectSpacePosition);
float3 _Lerp_9cfca9aa08c7423bab62b39a01237d64_Out_3_Vector3;
Unity_Lerp_float3(_Property_626923dc627443639da97776de7dcc22_Out_0_Vector3, (_Fog_acabe3c84c9549f3880ce7d106150576_Color_0_Vector4.xyz), (_Fog_acabe3c84c9549f3880ce7d106150576_Density_1_Float.xxx), _Lerp_9cfca9aa08c7423bab62b39a01237d64_Out_3_Vector3);
Out_1 = _Lerp_9cfca9aa08c7423bab62b39a01237d64_Out_3_Vector3;
}

struct Bindings_LightURP_17836dba1a675e246923104447b19cbd_float
{
float3 WorldSpaceNormal;
float3 WorldSpaceTangent;
float3 WorldSpaceBiTangent;
float3 WorldSpaceViewDirection;
float3 ObjectSpacePosition;
float3 WorldSpacePosition;
float3 AbsoluteWorldSpacePosition;
float2 NDCPosition;
float2 PixelPosition;
half4 uv1;
half4 uv2;
};

void SG_LightURP_17836dba1a675e246923104447b19cbd_float(float3 _Base_Color, float3 _Normal, bool _Normal_e1611e545480449d80aa5a0e7c2b63c4_IsConnected, float _Metallic, float _Smoothness, float _Ambient_Occlusion, float _Micro_Occlusion, Bindings_LightURP_17836dba1a675e246923104447b19cbd_float IN, out float3 Lit_1)
{
float3 _Property_6ed4205d0e494d9fbe20d17c4850dd01_Out_0_Vector3 = _Base_Color;
float3 _Property_625b0af59fbf4eb3846fcad626b34ca0_Out_0_Vector3 = _Base_Color;
float3 _Property_dbe43d633d7c40db91271fec54a22ee2_Out_0_Vector3 = _Normal;
bool _Property_dbe43d633d7c40db91271fec54a22ee2_Out_0_Vector3_IsConnected = _Normal_e1611e545480449d80aa5a0e7c2b63c4_IsConnected;
float3 _Transform_e8dcf06340124e7d8017300bc4dcb2c9_Out_1_Vector3;
{
float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
_Transform_e8dcf06340124e7d8017300bc4dcb2c9_Out_1_Vector3 = TransformTangentToWorld(_Property_dbe43d633d7c40db91271fec54a22ee2_Out_0_Vector3.xyz, tangentTransform, true);
}
float3 _BranchOnInputConnection_b3c5feecd28b43998390fb43ac1592b1_Out_3_Vector3 = _Property_dbe43d633d7c40db91271fec54a22ee2_Out_0_Vector3_IsConnected ? _Transform_e8dcf06340124e7d8017300bc4dcb2c9_Out_1_Vector3 : IN.WorldSpaceNormal;
float _Property_c5baaae739ad42b392a1b796ed36950b_Out_0_Float = _Metallic;
float _Property_ac10139ecedb4301b4595fa5b13c00b8_Out_0_Float = _Smoothness;
float3 _Property_8ab90e0aaf6a448083ce06c935d78437_Out_0_Vector3 = _Base_Color;
float _Property_2218b1e4c2a849809a373d68812e2b9e_Out_0_Float = _Metallic;
float _Property_732cd42e013c4b79b1d2ba9bc0bad8a6_Out_0_Float = _Smoothness;
float _Property_fdd3b516f2aa41159cf35a16e66b941f_Out_0_Float = _Micro_Occlusion;
float _Multiply_27f0b930a5b849e48209ca66e62866fe_Out_2_Float;
Unity_Multiply_float_float(_Property_fdd3b516f2aa41159cf35a16e66b941f_Out_0_Float, 0.5, _Multiply_27f0b930a5b849e48209ca66e62866fe_Out_2_Float);
float _Lerp_abfa5aa3eaeb4132b82e92eea93328aa_Out_3_Float;
Unity_Lerp_float(float(0), float(0.08), _Multiply_27f0b930a5b849e48209ca66e62866fe_Out_2_Float, _Lerp_abfa5aa3eaeb4132b82e92eea93328aa_Out_3_Float);
Bindings_ReflectanceURP_57a8ea7c8f931c941b2bb57aedc451aa_float _ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d;
_ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d.WorldSpaceNormal = IN.WorldSpaceNormal;
_ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
half3 _ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d_Reflectance_1_Vector3;
SG_ReflectanceURP_57a8ea7c8f931c941b2bb57aedc451aa_float(_Property_8ab90e0aaf6a448083ce06c935d78437_Out_0_Vector3, _BranchOnInputConnection_b3c5feecd28b43998390fb43ac1592b1_Out_3_Vector3, true, _Property_2218b1e4c2a849809a373d68812e2b9e_Out_0_Float, _Property_732cd42e013c4b79b1d2ba9bc0bad8a6_Out_0_Float, _Lerp_abfa5aa3eaeb4132b82e92eea93328aa_Out_3_Float, _ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d, _ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d_Reflectance_1_Vector3);
float _Property_0a056a259612407e813453c548affc50_Out_0_Float = _Ambient_Occlusion;
float _Split_065289545529474a93092a5b161c8bd9_R_1_Float = _Property_dbe43d633d7c40db91271fec54a22ee2_Out_0_Vector3[0];
float _Split_065289545529474a93092a5b161c8bd9_G_2_Float = _Property_dbe43d633d7c40db91271fec54a22ee2_Out_0_Vector3[1];
float _Split_065289545529474a93092a5b161c8bd9_B_3_Float = _Property_dbe43d633d7c40db91271fec54a22ee2_Out_0_Vector3[2];
float _Split_065289545529474a93092a5b161c8bd9_A_4_Float = 0;
float _FresnelEffect_66e2f70f47b04f11b7e25a61d65634e3_Out_3_Float;
Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, float(1), _FresnelEffect_66e2f70f47b04f11b7e25a61d65634e3_Out_3_Float);
float _Lerp_e6a5bc336b4d4fa48faf4eabd1b187b7_Out_3_Float;
Unity_Lerp_float(_Split_065289545529474a93092a5b161c8bd9_B_3_Float, float(1), _FresnelEffect_66e2f70f47b04f11b7e25a61d65634e3_Out_3_Float, _Lerp_e6a5bc336b4d4fa48faf4eabd1b187b7_Out_3_Float);
float _Multiply_2f54e3d54d4542f989d1875f64f31280_Out_2_Float;
Unity_Multiply_float_float(_Property_0a056a259612407e813453c548affc50_Out_0_Float, _Lerp_e6a5bc336b4d4fa48faf4eabd1b187b7_Out_3_Float, _Multiply_2f54e3d54d4542f989d1875f64f31280_Out_2_Float);
Bindings_AmbientURP_300875fdd653fe340b08ad1547984cf1_float _AmbientURP_46e1712500da4aae848bd5b24a05f29f;
_AmbientURP_46e1712500da4aae848bd5b24a05f29f.WorldSpaceNormal = IN.WorldSpaceNormal;
_AmbientURP_46e1712500da4aae848bd5b24a05f29f.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
_AmbientURP_46e1712500da4aae848bd5b24a05f29f.WorldSpacePosition = IN.WorldSpacePosition;
_AmbientURP_46e1712500da4aae848bd5b24a05f29f.NDCPosition = IN.NDCPosition;
_AmbientURP_46e1712500da4aae848bd5b24a05f29f.PixelPosition = IN.PixelPosition;
_AmbientURP_46e1712500da4aae848bd5b24a05f29f.uv1 = IN.uv1;
_AmbientURP_46e1712500da4aae848bd5b24a05f29f.uv2 = IN.uv2;
half3 _AmbientURP_46e1712500da4aae848bd5b24a05f29f_Ambient_1_Vector3;
half _AmbientURP_46e1712500da4aae848bd5b24a05f29f_DirectAO_2_Float;
SG_AmbientURP_300875fdd653fe340b08ad1547984cf1_float(_Property_625b0af59fbf4eb3846fcad626b34ca0_Out_0_Vector3, _BranchOnInputConnection_b3c5feecd28b43998390fb43ac1592b1_Out_3_Vector3, true, _Property_c5baaae739ad42b392a1b796ed36950b_Out_0_Float, _Property_ac10139ecedb4301b4595fa5b13c00b8_Out_0_Float, _ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d_Reflectance_1_Vector3, _Multiply_2f54e3d54d4542f989d1875f64f31280_Out_2_Float, _AmbientURP_46e1712500da4aae848bd5b24a05f29f, _AmbientURP_46e1712500da4aae848bd5b24a05f29f_Ambient_1_Vector3, _AmbientURP_46e1712500da4aae848bd5b24a05f29f_DirectAO_2_Float);
float3 _Multiply_a9decac7cda34291a6910c4cd9ad2700_Out_2_Vector3;
Unity_Multiply_float3_float3(_Property_6ed4205d0e494d9fbe20d17c4850dd01_Out_0_Vector3, (_AmbientURP_46e1712500da4aae848bd5b24a05f29f_DirectAO_2_Float.xxx), _Multiply_a9decac7cda34291a6910c4cd9ad2700_Out_2_Vector3);
float _Property_27a5774949ff4e6c9d8808560c39bc95_Out_0_Float = _Metallic;
float3 _Lerp_7894dcaa210343cc83783b010da9c85c_Out_3_Vector3;
Unity_Lerp_float3(_Multiply_a9decac7cda34291a6910c4cd9ad2700_Out_2_Vector3, float3(0, 0, 0), (_Property_27a5774949ff4e6c9d8808560c39bc95_Out_0_Float.xxx), _Lerp_7894dcaa210343cc83783b010da9c85c_Out_3_Vector3);
Bindings_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float _MainLight_d918d0814080438585a810ba0b8afeb4;
_MainLight_d918d0814080438585a810ba0b8afeb4.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
half3 _MainLight_d918d0814080438585a810ba0b8afeb4_Direction_1_Vector3;
half3 _MainLight_d918d0814080438585a810ba0b8afeb4_Color_2_Vector3;
half _MainLight_d918d0814080438585a810ba0b8afeb4_ShadowAtten_3_Float;
SG_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float(_MainLight_d918d0814080438585a810ba0b8afeb4, _MainLight_d918d0814080438585a810ba0b8afeb4_Direction_1_Vector3, _MainLight_d918d0814080438585a810ba0b8afeb4_Color_2_Vector3, _MainLight_d918d0814080438585a810ba0b8afeb4_ShadowAtten_3_Float);
Bindings_DiffuseLambert_cb5cb9cef826e9f448011787f0d627b2_half _DiffuseLambert_7f9e988376a2438ebc87097469e065d3;
_DiffuseLambert_7f9e988376a2438ebc87097469e065d3.WorldSpaceNormal = IN.WorldSpaceNormal;
_DiffuseLambert_7f9e988376a2438ebc87097469e065d3.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
half _DiffuseLambert_7f9e988376a2438ebc87097469e065d3_Diffuse_1_Float;
SG_DiffuseLambert_cb5cb9cef826e9f448011787f0d627b2_half(_BranchOnInputConnection_b3c5feecd28b43998390fb43ac1592b1_Out_3_Vector3, true, _MainLight_d918d0814080438585a810ba0b8afeb4_Direction_1_Vector3, true, _DiffuseLambert_7f9e988376a2438ebc87097469e065d3, _DiffuseLambert_7f9e988376a2438ebc87097469e065d3_Diffuse_1_Float);
float _Property_a888856c392c4ddfbc144ff5ed452e65_Out_0_Float = _Smoothness;
float _Clamp_6b8538ec3747440bbd39832354f4c497_Out_3_Float;
Unity_Clamp_float(_Property_a888856c392c4ddfbc144ff5ed452e65_Out_0_Float, float(0), float(0.94), _Clamp_6b8538ec3747440bbd39832354f4c497_Out_3_Float);
Bindings_SpecularURP_836ccbead8eba604dae19317e6fd4f6f_half _SpecularURP_bb88623835294209a6f5bbddb1ba7f22;
_SpecularURP_bb88623835294209a6f5bbddb1ba7f22.WorldSpaceNormal = IN.WorldSpaceNormal;
_SpecularURP_bb88623835294209a6f5bbddb1ba7f22.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
_SpecularURP_bb88623835294209a6f5bbddb1ba7f22.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
half3 _SpecularURP_bb88623835294209a6f5bbddb1ba7f22_Specular_1_Vector3;
SG_SpecularURP_836ccbead8eba604dae19317e6fd4f6f_half(_BranchOnInputConnection_b3c5feecd28b43998390fb43ac1592b1_Out_3_Vector3, true, _Clamp_6b8538ec3747440bbd39832354f4c497_Out_3_Float, _ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d_Reflectance_1_Vector3, _MainLight_d918d0814080438585a810ba0b8afeb4_Direction_1_Vector3, true, _SpecularURP_bb88623835294209a6f5bbddb1ba7f22, _SpecularURP_bb88623835294209a6f5bbddb1ba7f22_Specular_1_Vector3);
half3 _Multiply_610f130d22274970bc454dfea38393cd_Out_2_Vector3;
Unity_Multiply_half3_half3((_DiffuseLambert_7f9e988376a2438ebc87097469e065d3_Diffuse_1_Float.xxx), _SpecularURP_bb88623835294209a6f5bbddb1ba7f22_Specular_1_Vector3, _Multiply_610f130d22274970bc454dfea38393cd_Out_2_Vector3);
Bindings_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float _MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e;
_MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
half3 _MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e_Direction_1_Vector3;
half3 _MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e_Color_2_Vector3;
half _MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e_ShadowAtten_3_Float;
SG_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float(_MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e, _MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e_Direction_1_Vector3, _MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e_Color_2_Vector3, _MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e_ShadowAtten_3_Float);
float3 _Multiply_9545e2014858428792b92c57dd77e45c_Out_2_Vector3;
Unity_Multiply_float3_float3(_MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e_Color_2_Vector3, (_MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e_ShadowAtten_3_Float.xxx), _Multiply_9545e2014858428792b92c57dd77e45c_Out_2_Vector3);
Bindings_AdditionalLightsURP_97b36dcc0c1df064bab3b4b47d231089_float _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd;
_AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd.WorldSpaceNormal = IN.WorldSpaceNormal;
_AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
_AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
_AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd.NDCPosition = IN.NDCPosition;
half _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Diffuse_1_Float;
half3 _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Specular_2_Vector3;
half3 _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Color_3_Vector3;
SG_AdditionalLightsURP_97b36dcc0c1df064bab3b4b47d231089_float(_DiffuseLambert_7f9e988376a2438ebc87097469e065d3_Diffuse_1_Float, _Multiply_610f130d22274970bc454dfea38393cd_Out_2_Vector3, _Multiply_9545e2014858428792b92c57dd77e45c_Out_2_Vector3, _BranchOnInputConnection_b3c5feecd28b43998390fb43ac1592b1_Out_3_Vector3, true, _Clamp_6b8538ec3747440bbd39832354f4c497_Out_3_Float, _ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d_Reflectance_1_Vector3, _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd, _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Diffuse_1_Float, _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Specular_2_Vector3, _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Color_3_Vector3);
float3 _Multiply_765841b19beb4cecb786b3295b6aa8e9_Out_2_Vector3;
Unity_Multiply_float3_float3(_Lerp_7894dcaa210343cc83783b010da9c85c_Out_3_Vector3, (_AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Diffuse_1_Float.xxx), _Multiply_765841b19beb4cecb786b3295b6aa8e9_Out_2_Vector3);
float3 _Multiply_90e8c848b8014b22847c7d7e2db6bcf9_Out_2_Vector3;
Unity_Multiply_float3_float3(_AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Specular_2_Vector3, (_AmbientURP_46e1712500da4aae848bd5b24a05f29f_DirectAO_2_Float.xxx), _Multiply_90e8c848b8014b22847c7d7e2db6bcf9_Out_2_Vector3);
float3 _Add_77980781d2204e1b8d249e5f7058e9fb_Out_2_Vector3;
Unity_Add_float3(_Multiply_765841b19beb4cecb786b3295b6aa8e9_Out_2_Vector3, _Multiply_90e8c848b8014b22847c7d7e2db6bcf9_Out_2_Vector3, _Add_77980781d2204e1b8d249e5f7058e9fb_Out_2_Vector3);
float3 _Multiply_9df1a4a5bf654e97b945b2eccf2fc855_Out_2_Vector3;
Unity_Multiply_float3_float3(_Add_77980781d2204e1b8d249e5f7058e9fb_Out_2_Vector3, _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Color_3_Vector3, _Multiply_9df1a4a5bf654e97b945b2eccf2fc855_Out_2_Vector3);
float3 _Add_ad0b3eccabf24dceb374546c3c332ad7_Out_2_Vector3;
Unity_Add_float3(_Multiply_9df1a4a5bf654e97b945b2eccf2fc855_Out_2_Vector3, _AmbientURP_46e1712500da4aae848bd5b24a05f29f_Ambient_1_Vector3, _Add_ad0b3eccabf24dceb374546c3c332ad7_Out_2_Vector3);
Bindings_Fog_286ae83400099a24bba6faf005588be7_float _Fog_4b5ff09555f14324848244007e17d043;
_Fog_4b5ff09555f14324848244007e17d043.ObjectSpacePosition = IN.ObjectSpacePosition;
half3 _Fog_4b5ff09555f14324848244007e17d043_Out_1_Vector3;
SG_Fog_286ae83400099a24bba6faf005588be7_float(_Add_ad0b3eccabf24dceb374546c3c332ad7_Out_2_Vector3, _Fog_4b5ff09555f14324848244007e17d043, _Fog_4b5ff09555f14324848244007e17d043_Out_1_Vector3);
Lit_1 = _Fog_4b5ff09555f14324848244007e17d043_Out_1_Vector3;
}

// unity-custom-func-begin
void DebugMaterialSwitch_float(float3 None, float3 Albedo, float3 Specular, float3 Alpha, float3 Smoothness, float3 AmbientOcclusion, float3 Emission, float3 NormalWS, float3 NormalTS, float3 LightComplexity, float3 Metallic, float3 SpriteMask, float3 RenderingLayerMasks, out float3 Out){
Out = None;
#if !defined(SHADERGRAPH_PREVIEW) && defined(DEBUG_DISPLAY)
[branch] switch(int(_DebugMaterialMode))

{

    case 0:

        Out = None; break;

    case 1:

        Out = Albedo; break;

    case 2:

        Out = Specular; break;
    case 3:

        Out = Alpha; break;
    case 4:

        Out = Smoothness; break;
    case 5:

        Out = AmbientOcclusion;  break;
    case 6:

        Out = Emission;  break;
    case 7:

        Out = NormalWS * 0.5 + 0.5;  break;
    case 8:

        Out = NormalTS * 0.5 + 0.5;  break;
    case 9:

        Out = LightComplexity;  break;
    case 10:

        Out = Metallic;  break;
    case 11:

        Out = SpriteMask;  break;
    case 12:

        Out = RenderingLayerMasks;  break;

    default:

        Out = None; break;

}
#endif

// Disable this define to prevent the global unlit
// fragment pass to override the color output again.
#undef DEBUG_DISPLAY
}
// unity-custom-func-end

struct Bindings_DebugMaterials_53d20e1f36b55014f99f9ccae649c798_float
{
float3 WorldSpaceNormal;
float3 WorldSpaceTangent;
float3 WorldSpaceBiTangent;
float3 WorldSpacePosition;
float2 NDCPosition;
};

void SG_DebugMaterials_53d20e1f36b55014f99f9ccae649c798_float(float3 _In, float3 _Base_Color, float3 _Normal, float _Metallic, float _Smoothness, float3 _Emission, float _Ambient_Occlusion, float _Alpha, Bindings_DebugMaterials_53d20e1f36b55014f99f9ccae649c798_float IN, out float3 Out_1)
{
float3 _Property_dd011cc96ae64d1181317986b1fa1742_Out_0_Vector3 = _In;
float3 _Property_5653941ce5a641f18f7ce7012652025d_Out_0_Vector3 = _Base_Color;
float _Property_45f5c13ff5544581bd61c2442cecd0a1_Out_0_Float = _Alpha;
float _Property_b6c8b448c5324bd3bc59540f628e43a3_Out_0_Float = _Smoothness;
Bindings_ScreenSpaceAmbientOcclusion_616a08cdf385c2d4997a5ed9d01e16a8_float _ScreenSpaceAmbientOcclusion_40f694c4c3ca4e89acb75242921983f5;
_ScreenSpaceAmbientOcclusion_40f694c4c3ca4e89acb75242921983f5.NDCPosition = IN.NDCPosition;
half _ScreenSpaceAmbientOcclusion_40f694c4c3ca4e89acb75242921983f5_indirectAO_1_Float;
half _ScreenSpaceAmbientOcclusion_40f694c4c3ca4e89acb75242921983f5_directAO_2_Float;
SG_ScreenSpaceAmbientOcclusion_616a08cdf385c2d4997a5ed9d01e16a8_float(_ScreenSpaceAmbientOcclusion_40f694c4c3ca4e89acb75242921983f5, _ScreenSpaceAmbientOcclusion_40f694c4c3ca4e89acb75242921983f5_indirectAO_1_Float, _ScreenSpaceAmbientOcclusion_40f694c4c3ca4e89acb75242921983f5_directAO_2_Float);
float _Property_441143660ff642349088dd1bcab6bc78_Out_0_Float = _Ambient_Occlusion;
float _Minimum_8ee95b9bf7ac4776b6ee4edf1214b3c1_Out_2_Float;
Unity_Minimum_float(_ScreenSpaceAmbientOcclusion_40f694c4c3ca4e89acb75242921983f5_indirectAO_1_Float, _Property_441143660ff642349088dd1bcab6bc78_Out_0_Float, _Minimum_8ee95b9bf7ac4776b6ee4edf1214b3c1_Out_2_Float);
float3 _Property_b171431b5a3b4b0a9fc9fdede4a532a7_Out_0_Vector3 = _Emission;
float3 _Property_db9eb36ed51d4aad95e383920b55e3d7_Out_0_Vector3 = _Normal;
float3 _Transform_9e831bda1f4d4495b24f1f6e3075f2fb_Out_1_Vector3;
{
float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
_Transform_9e831bda1f4d4495b24f1f6e3075f2fb_Out_1_Vector3 = TransformTangentToWorld(_Property_db9eb36ed51d4aad95e383920b55e3d7_Out_0_Vector3.xyz, tangentTransform, true);
}
float3 _Property_4eaab22b2b784aeda3752622f7abaf85_Out_0_Vector3 = _Normal;
float4 _ScreenPosition_121436dfdd464829910775b2326b046b_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
float3 _Property_1b1e0a48277e4883afeb1289a075c5d8_Out_0_Vector3 = _Base_Color;
float3 _LightingComplexityCustomFunction_cbe0c0f96f9046a584e17ead8c001a55_Out_3_Vector3;
LightingComplexity_float((_ScreenPosition_121436dfdd464829910775b2326b046b_Out_0_Vector4.xy), IN.WorldSpacePosition, _Property_1b1e0a48277e4883afeb1289a075c5d8_Out_0_Vector3, _LightingComplexityCustomFunction_cbe0c0f96f9046a584e17ead8c001a55_Out_3_Vector3);
float _Property_dcd3ca7796af45c6857884fa7979898b_Out_0_Float = _Metallic;
float3 _DebugMaterialSwitchCustomFunction_e1fabc2a3bcd4bc183f0e93c379657d4_Out_5_Vector3;
DebugMaterialSwitch_float(_Property_dd011cc96ae64d1181317986b1fa1742_Out_0_Vector3, _Property_5653941ce5a641f18f7ce7012652025d_Out_0_Vector3, float3 (0, 0, 0), (_Property_45f5c13ff5544581bd61c2442cecd0a1_Out_0_Float.xxx), (_Property_b6c8b448c5324bd3bc59540f628e43a3_Out_0_Float.xxx), (_Minimum_8ee95b9bf7ac4776b6ee4edf1214b3c1_Out_2_Float.xxx), _Property_b171431b5a3b4b0a9fc9fdede4a532a7_Out_0_Vector3, _Transform_9e831bda1f4d4495b24f1f6e3075f2fb_Out_1_Vector3, _Property_4eaab22b2b784aeda3752622f7abaf85_Out_0_Vector3, _LightingComplexityCustomFunction_cbe0c0f96f9046a584e17ead8c001a55_Out_3_Vector3, (_Property_dcd3ca7796af45c6857884fa7979898b_Out_0_Float.xxx), float3 (0, 0, 0), float3 (0, 0, 0), _DebugMaterialSwitchCustomFunction_e1fabc2a3bcd4bc183f0e93c379657d4_Out_5_Vector3);
Out_1 = _DebugMaterialSwitchCustomFunction_e1fabc2a3bcd4bc183f0e93c379657d4_Out_5_Vector3;
}

struct Bindings_LitURP_fd8fe8e9e251a39419530ac6ee5a5b61_float
{
float3 WorldSpaceNormal;
float3 WorldSpaceTangent;
float3 WorldSpaceBiTangent;
float3 WorldSpaceViewDirection;
float3 ObjectSpacePosition;
float3 WorldSpacePosition;
float3 AbsoluteWorldSpacePosition;
float2 NDCPosition;
float2 PixelPosition;
half4 uv1;
half4 uv2;
};

void SG_LitURP_fd8fe8e9e251a39419530ac6ee5a5b61_float(float3 _Base_Color, float3 _Normal, float _Metallic, float _Smoothness, float3 _Emission, float _AmbientOcclusion, float _Alpha, Bindings_LitURP_fd8fe8e9e251a39419530ac6ee5a5b61_float IN, out float3 Lit_1)
{
float3 _Property_04a055764411443d802bfbbd0d510c65_Out_0_Vector3 = _Base_Color;
float3 _Property_383a017d83a8420dac016260bc833f58_Out_0_Vector3 = _Normal;
float3 _Transform_3f94cf9dbe844abc9b6727d5d289074f_Out_1_Vector3;
{
float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
_Transform_3f94cf9dbe844abc9b6727d5d289074f_Out_1_Vector3 = TransformTangentToWorld(_Property_383a017d83a8420dac016260bc833f58_Out_0_Vector3.xyz, tangentTransform, true);
}
float _Property_11295d868ff34c388c9212b90b781aff_Out_0_Float = _Metallic;
float _Property_b522b61b85ff4ecbb0eb63cff689f5cb_Out_0_Float = _Smoothness;
float _Property_a1dc37a47c5640d0870861199df0bd70_Out_0_Float = _AmbientOcclusion;
Bindings_ApplyDecals_66e8fc89f7971da4c8964580a0eb9f80_float _ApplyDecals_0413903f5da5491d911d117142eabddd;
_ApplyDecals_0413903f5da5491d911d117142eabddd.PixelPosition = IN.PixelPosition;
half3 _ApplyDecals_0413903f5da5491d911d117142eabddd_BaseColor_1_Vector3;
half3 _ApplyDecals_0413903f5da5491d911d117142eabddd_SpecularColor_2_Vector3;
half3 _ApplyDecals_0413903f5da5491d911d117142eabddd_NormalWS_3_Vector3;
half _ApplyDecals_0413903f5da5491d911d117142eabddd_Metallic_4_Float;
half _ApplyDecals_0413903f5da5491d911d117142eabddd_Smoothness_6_Float;
half _ApplyDecals_0413903f5da5491d911d117142eabddd_AmbientOcclusion_5_Float;
SG_ApplyDecals_66e8fc89f7971da4c8964580a0eb9f80_float(_Property_04a055764411443d802bfbbd0d510c65_Out_0_Vector3, _Transform_3f94cf9dbe844abc9b6727d5d289074f_Out_1_Vector3, _Property_11295d868ff34c388c9212b90b781aff_Out_0_Float, _Property_b522b61b85ff4ecbb0eb63cff689f5cb_Out_0_Float, _Property_a1dc37a47c5640d0870861199df0bd70_Out_0_Float, _ApplyDecals_0413903f5da5491d911d117142eabddd, _ApplyDecals_0413903f5da5491d911d117142eabddd_BaseColor_1_Vector3, _ApplyDecals_0413903f5da5491d911d117142eabddd_SpecularColor_2_Vector3, _ApplyDecals_0413903f5da5491d911d117142eabddd_NormalWS_3_Vector3, _ApplyDecals_0413903f5da5491d911d117142eabddd_Metallic_4_Float, _ApplyDecals_0413903f5da5491d911d117142eabddd_Smoothness_6_Float, _ApplyDecals_0413903f5da5491d911d117142eabddd_AmbientOcclusion_5_Float);
float3 _Property_b986326ad9b34d6ea3a7237ba2bd1cd6_Out_0_Vector3 = _Emission;
Bindings_DebugLighting_61e571d2b9ede1240a524a849d20c997_float _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9;
_DebugLighting_7c013feaa8eb4525bc13d6e4722049d9.WorldSpaceNormal = IN.WorldSpaceNormal;
_DebugLighting_7c013feaa8eb4525bc13d6e4722049d9.WorldSpaceTangent = IN.WorldSpaceTangent;
_DebugLighting_7c013feaa8eb4525bc13d6e4722049d9.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
_DebugLighting_7c013feaa8eb4525bc13d6e4722049d9.WorldSpacePosition = IN.WorldSpacePosition;
_DebugLighting_7c013feaa8eb4525bc13d6e4722049d9.PixelPosition = IN.PixelPosition;
_DebugLighting_7c013feaa8eb4525bc13d6e4722049d9.uv1 = IN.uv1;
_DebugLighting_7c013feaa8eb4525bc13d6e4722049d9.uv2 = IN.uv2;
float3 _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_BaseColor_1_Vector3;
float3 _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Normal_4_Vector3;
float _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Metallic_2_Float;
float _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Smoothness_3_Float;
float3 _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Emission_5_Vector3;
float _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_AmbientOcclusion_6_Float;
SG_DebugLighting_61e571d2b9ede1240a524a849d20c997_float(_ApplyDecals_0413903f5da5491d911d117142eabddd_BaseColor_1_Vector3, _ApplyDecals_0413903f5da5491d911d117142eabddd_NormalWS_3_Vector3, _ApplyDecals_0413903f5da5491d911d117142eabddd_Metallic_4_Float, _ApplyDecals_0413903f5da5491d911d117142eabddd_Smoothness_6_Float, _Property_b986326ad9b34d6ea3a7237ba2bd1cd6_Out_0_Vector3, _ApplyDecals_0413903f5da5491d911d117142eabddd_AmbientOcclusion_5_Float, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_BaseColor_1_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Normal_4_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Metallic_2_Float, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Smoothness_3_Float, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Emission_5_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_AmbientOcclusion_6_Float);
Bindings_LightURP_17836dba1a675e246923104447b19cbd_float _LightURP_4a271a100e74437fb7dc277976b6febf;
_LightURP_4a271a100e74437fb7dc277976b6febf.WorldSpaceNormal = IN.WorldSpaceNormal;
_LightURP_4a271a100e74437fb7dc277976b6febf.WorldSpaceTangent = IN.WorldSpaceTangent;
_LightURP_4a271a100e74437fb7dc277976b6febf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
_LightURP_4a271a100e74437fb7dc277976b6febf.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
_LightURP_4a271a100e74437fb7dc277976b6febf.ObjectSpacePosition = IN.ObjectSpacePosition;
_LightURP_4a271a100e74437fb7dc277976b6febf.WorldSpacePosition = IN.WorldSpacePosition;
_LightURP_4a271a100e74437fb7dc277976b6febf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
_LightURP_4a271a100e74437fb7dc277976b6febf.NDCPosition = IN.NDCPosition;
_LightURP_4a271a100e74437fb7dc277976b6febf.PixelPosition = IN.PixelPosition;
_LightURP_4a271a100e74437fb7dc277976b6febf.uv1 = IN.uv1;
_LightURP_4a271a100e74437fb7dc277976b6febf.uv2 = IN.uv2;
half3 _LightURP_4a271a100e74437fb7dc277976b6febf_Lit_1_Vector3;
SG_LightURP_17836dba1a675e246923104447b19cbd_float(_DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_BaseColor_1_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Normal_4_Vector3, true, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Metallic_2_Float, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Smoothness_3_Float, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_AmbientOcclusion_6_Float, half(1), _LightURP_4a271a100e74437fb7dc277976b6febf, _LightURP_4a271a100e74437fb7dc277976b6febf_Lit_1_Vector3);
float3 _Add_a11e24e7d4fd4494895fd67f375acb21_Out_2_Vector3;
Unity_Add_float3(_LightURP_4a271a100e74437fb7dc277976b6febf_Lit_1_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Emission_5_Vector3, _Add_a11e24e7d4fd4494895fd67f375acb21_Out_2_Vector3);
float _Property_d5e8251fc84a46aea1765511445b653e_Out_0_Float = _Alpha;
Bindings_DebugMaterials_53d20e1f36b55014f99f9ccae649c798_float _DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3;
_DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3.WorldSpaceNormal = IN.WorldSpaceNormal;
_DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3.WorldSpaceTangent = IN.WorldSpaceTangent;
_DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
_DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3.WorldSpacePosition = IN.WorldSpacePosition;
_DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3.NDCPosition = IN.NDCPosition;
float3 _DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3_Out_1_Vector3;
SG_DebugMaterials_53d20e1f36b55014f99f9ccae649c798_float(_Add_a11e24e7d4fd4494895fd67f375acb21_Out_2_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_BaseColor_1_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Normal_4_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Metallic_2_Float, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Smoothness_3_Float, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Emission_5_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_AmbientOcclusion_6_Float, _Property_d5e8251fc84a46aea1765511445b653e_Out_0_Float, _DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3, _DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3_Out_1_Vector3);
Lit_1 = _DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3_Out_1_Vector3;
}

void Unity_ColorspaceConversion_RGB_HSV_float(float3 In, out float3 Out)
{
    float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    float4 P = lerp(float4(In.bg, K.wz), float4(In.gb, K.xy), step(In.b, In.g));
    float4 Q = lerp(float4(P.xyw, In.r), float4(In.r, P.yzx), step(P.x, In.r));
    float D = Q.x - min(Q.w, Q.y);
    float  E = 1e-10;
    float V = (D == 0) ? Q.x : (Q.x + E);
    Out = float3(abs(Q.z + (Q.w - Q.y)/(6.0 * D + E)), D / (Q.x + E), V);
}

void Unity_Floor_float(float In, out float Out)
{
    Out = floor(In);
}

void Unity_Fraction_float(float In, out float Out)
{
    Out = frac(In);
}

void Unity_Power_float(float A, float B, out float Out)
{
    Out = pow(A, B);
}

void Unity_Sign_float(float In, out float Out)
{
    Out = sign(In);
}

struct Bindings_DynamicSCurve_3565967296b1b074e9007137bcb40394_float
{
};

void SG_DynamicSCurve_3565967296b1b074e9007137bcb40394_float(float _Transition_Sharpness, float _Value, Bindings_DynamicSCurve_3565967296b1b074e9007137bcb40394_float IN, out float Output_2)
{
float _Property_dcf147b7545042b199ca74d23fcbd205_Out_0_Float = _Value;
float _Add_eb03fff2d84e49d587a7742a4b9d1911_Out_2_Float;
Unity_Add_float(_Property_dcf147b7545042b199ca74d23fcbd205_Out_0_Float, _Property_dcf147b7545042b199ca74d23fcbd205_Out_0_Float, _Add_eb03fff2d84e49d587a7742a4b9d1911_Out_2_Float);
float _Property_b6803ebab1d14e28a59f3f0620bc01fe_Out_0_Float = _Transition_Sharpness;
float _Clamp_babb9473387444bba43958a0a940ee34_Out_3_Float;
Unity_Clamp_float(_Property_b6803ebab1d14e28a59f3f0620bc01fe_Out_0_Float, float(0), float(0.99), _Clamp_babb9473387444bba43958a0a940ee34_Out_3_Float);
float _OneMinus_d216a1afb61246768fbf941a2d1a8328_Out_1_Float;
Unity_OneMinus_float(_Clamp_babb9473387444bba43958a0a940ee34_Out_3_Float, _OneMinus_d216a1afb61246768fbf941a2d1a8328_Out_1_Float);
float _Divide_34a05d03980341a3971de4b91620a5bf_Out_2_Float;
Unity_Divide_float(float(1), _OneMinus_d216a1afb61246768fbf941a2d1a8328_Out_1_Float, _Divide_34a05d03980341a3971de4b91620a5bf_Out_2_Float);
float _Power_7b42c3f5820c4805814fd7552688ab96_Out_2_Float;
Unity_Power_float(_Add_eb03fff2d84e49d587a7742a4b9d1911_Out_2_Float, _Divide_34a05d03980341a3971de4b91620a5bf_Out_2_Float, _Power_7b42c3f5820c4805814fd7552688ab96_Out_2_Float);
float _Subtract_12c9f1648de341b4a45af3973e5b972c_Out_2_Float;
Unity_Subtract_float(_Property_dcf147b7545042b199ca74d23fcbd205_Out_0_Float, float(0.5), _Subtract_12c9f1648de341b4a45af3973e5b972c_Out_2_Float);
float _Sign_862dd10c92de4dceb317f801dea4f2d9_Out_1_Float;
Unity_Sign_float(_Subtract_12c9f1648de341b4a45af3973e5b972c_Out_2_Float, _Sign_862dd10c92de4dceb317f801dea4f2d9_Out_1_Float);
float _Add_a2d7a5f001944c6496ce3466c7d6c666_Out_2_Float;
Unity_Add_float(_Sign_862dd10c92de4dceb317f801dea4f2d9_Out_1_Float, float(1), _Add_a2d7a5f001944c6496ce3466c7d6c666_Out_2_Float);
float _Subtract_644715ea3c054db6bc12c0813f096086_Out_2_Float;
Unity_Subtract_float(float(2), _Add_a2d7a5f001944c6496ce3466c7d6c666_Out_2_Float, _Subtract_644715ea3c054db6bc12c0813f096086_Out_2_Float);
float _Multiply_d380040a9ebb4cb5b081d93f3444d4bf_Out_2_Float;
Unity_Multiply_float_float(_Power_7b42c3f5820c4805814fd7552688ab96_Out_2_Float, _Subtract_644715ea3c054db6bc12c0813f096086_Out_2_Float, _Multiply_d380040a9ebb4cb5b081d93f3444d4bf_Out_2_Float);
float _Add_42fd94976e7c42e3a174031a3f7ed22f_Out_2_Float;
Unity_Add_float(_Property_dcf147b7545042b199ca74d23fcbd205_Out_0_Float, _Property_dcf147b7545042b199ca74d23fcbd205_Out_0_Float, _Add_42fd94976e7c42e3a174031a3f7ed22f_Out_2_Float);
float _Subtract_9ff8c56779f1472c846929dd11ae8e10_Out_2_Float;
Unity_Subtract_float(float(2), _Add_42fd94976e7c42e3a174031a3f7ed22f_Out_2_Float, _Subtract_9ff8c56779f1472c846929dd11ae8e10_Out_2_Float);
float _Power_db9493c407d3483a8dc3176196107278_Out_2_Float;
Unity_Power_float(_Subtract_9ff8c56779f1472c846929dd11ae8e10_Out_2_Float, _Divide_34a05d03980341a3971de4b91620a5bf_Out_2_Float, _Power_db9493c407d3483a8dc3176196107278_Out_2_Float);
float _Subtract_3dc49412d7464d2abf5ef1de774e77ff_Out_2_Float;
Unity_Subtract_float(float(2), _Power_db9493c407d3483a8dc3176196107278_Out_2_Float, _Subtract_3dc49412d7464d2abf5ef1de774e77ff_Out_2_Float);
float _Multiply_0a00edfeb8e549478444268e9aa69c00_Out_2_Float;
Unity_Multiply_float_float(_Subtract_3dc49412d7464d2abf5ef1de774e77ff_Out_2_Float, _Add_a2d7a5f001944c6496ce3466c7d6c666_Out_2_Float, _Multiply_0a00edfeb8e549478444268e9aa69c00_Out_2_Float);
float _Add_51a37a0e820549b2ace13c24825f6ff3_Out_2_Float;
Unity_Add_float(_Multiply_d380040a9ebb4cb5b081d93f3444d4bf_Out_2_Float, _Multiply_0a00edfeb8e549478444268e9aa69c00_Out_2_Float, _Add_51a37a0e820549b2ace13c24825f6ff3_Out_2_Float);
float _Multiply_3a2c209c0f54499aa9cd11f5bca1ac5e_Out_2_Float;
Unity_Multiply_float_float(_Add_51a37a0e820549b2ace13c24825f6ff3_Out_2_Float, 0.25, _Multiply_3a2c209c0f54499aa9cd11f5bca1ac5e_Out_2_Float);
Output_2 = _Multiply_3a2c209c0f54499aa9cd11f5bca1ac5e_Out_2_Float;
}

void Unity_Log2_float(float In, out float Out)
{
    Out = log2(In);
}

void Unity_ViewVectorWorld_float(out float3 Out, float3 WorldSpacePosition)
{
    Out = _WorldSpaceCameraPos.xyz - GetAbsolutePositionWS(WorldSpacePosition);
    if(!IsPerspectiveProjection())
    {
        Out = GetViewForwardDir() * dot(Out, GetViewForwardDir());
    }
}

void Unity_Arccosine_float(float In, out float Out)
{
    Out = acos(In);
}

void Unity_InverseLerp_float(float A, float B, float T, out float Out)
{
    Out = (T - A)/(B - A);
}

void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
{
    RGBA = float4(R, G, B, A);
    RGB = float3(R, G, B);
    RG = float2(R, G);
}

void Unity_ColorspaceConversion_HSV_RGB_float(float3 In, out float3 Out)
{
    float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    float3 P = abs(frac(In.xxx + K.xyz) * 6.0 - K.www);
    Out = In.z * lerp(K.xxx, saturate(P - K.xxx), In.y);
}

void Unity_Maximum_float3(float3 A, float3 B, out float3 Out)
{
    Out = max(A, B);
}

struct Bindings_CellLightingModel_28d05442c333727418ac448845e1326b_float
{
float3 WorldSpaceNormal;
float3 TangentSpaceNormal;
float3 WorldSpaceTangent;
float3 WorldSpaceBiTangent;
float3 WorldSpaceViewDirection;
float3 ObjectSpacePosition;
float3 WorldSpacePosition;
float3 AbsoluteWorldSpacePosition;
float2 NDCPosition;
float2 PixelPosition;
half4 uv1;
half4 uv2;
};

void SG_CellLightingModel_28d05442c333727418ac448845e1326b_float(float3 _Color, float3 _Normal, bool _Normal_cff37159d27a438f823fbf468c1fb985_IsConnected, float _Metallic, float _Smoothness, float4 _Emission, float _Ambient_Occlusion, float _Transition_Sharpness, float _Posterization, float _Posterization_Sharpness, float _Rim_Light, Bindings_CellLightingModel_28d05442c333727418ac448845e1326b_float IN, out float3 Color_2)
{
float3 _Property_4bd64118369b459398471ea412165b6d_Out_0_Vector3 = _Color;
float3 _Property_45e1be22194d4e5bac9c49dd235276b2_Out_0_Vector3 = _Normal;
bool _Property_45e1be22194d4e5bac9c49dd235276b2_Out_0_Vector3_IsConnected = _Normal_cff37159d27a438f823fbf468c1fb985_IsConnected;
float3 _BranchOnInputConnection_5509e94253aa40279af357154b1bfc82_Out_3_Vector3 = _Property_45e1be22194d4e5bac9c49dd235276b2_Out_0_Vector3_IsConnected ? _Property_45e1be22194d4e5bac9c49dd235276b2_Out_0_Vector3 : IN.TangentSpaceNormal;
float _Property_364c0d0968c04621a0f5089a26f94b35_Out_0_Float = _Metallic;
float _Property_ae8565d0591149cdbe7378e405bcaf4f_Out_0_Float = _Smoothness;
float4 _Property_47156e0140cb41ca8d7230103d68e17f_Out_0_Vector4 = _Emission;
float _Property_aabb3e299af744ee942d6adf77f21f65_Out_0_Float = _Ambient_Occlusion;
Bindings_LitURP_fd8fe8e9e251a39419530ac6ee5a5b61_float _LitURP_79042709b1054141888f9d40874c578b;
_LitURP_79042709b1054141888f9d40874c578b.WorldSpaceNormal = IN.WorldSpaceNormal;
_LitURP_79042709b1054141888f9d40874c578b.WorldSpaceTangent = IN.WorldSpaceTangent;
_LitURP_79042709b1054141888f9d40874c578b.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
_LitURP_79042709b1054141888f9d40874c578b.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
_LitURP_79042709b1054141888f9d40874c578b.ObjectSpacePosition = IN.ObjectSpacePosition;
_LitURP_79042709b1054141888f9d40874c578b.WorldSpacePosition = IN.WorldSpacePosition;
_LitURP_79042709b1054141888f9d40874c578b.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
_LitURP_79042709b1054141888f9d40874c578b.NDCPosition = IN.NDCPosition;
_LitURP_79042709b1054141888f9d40874c578b.PixelPosition = IN.PixelPosition;
_LitURP_79042709b1054141888f9d40874c578b.uv1 = IN.uv1;
_LitURP_79042709b1054141888f9d40874c578b.uv2 = IN.uv2;
half3 _LitURP_79042709b1054141888f9d40874c578b_Lit_1_Vector3;
SG_LitURP_fd8fe8e9e251a39419530ac6ee5a5b61_float(_Property_4bd64118369b459398471ea412165b6d_Out_0_Vector3, _BranchOnInputConnection_5509e94253aa40279af357154b1bfc82_Out_3_Vector3, _Property_364c0d0968c04621a0f5089a26f94b35_Out_0_Float, _Property_ae8565d0591149cdbe7378e405bcaf4f_Out_0_Float, (_Property_47156e0140cb41ca8d7230103d68e17f_Out_0_Vector4.xyz), _Property_aabb3e299af744ee942d6adf77f21f65_Out_0_Float, half(1), _LitURP_79042709b1054141888f9d40874c578b, _LitURP_79042709b1054141888f9d40874c578b_Lit_1_Vector3);
float3 _ColorspaceConversion_6887f2e74d5145928d4dde174bb981cf_Out_1_Vector3;
Unity_ColorspaceConversion_RGB_HSV_float(_LitURP_79042709b1054141888f9d40874c578b_Lit_1_Vector3, _ColorspaceConversion_6887f2e74d5145928d4dde174bb981cf_Out_1_Vector3);
float _Split_2b8b5bbad0b9449cab8a678b7257b571_R_1_Float = _ColorspaceConversion_6887f2e74d5145928d4dde174bb981cf_Out_1_Vector3[0];
float _Split_2b8b5bbad0b9449cab8a678b7257b571_G_2_Float = _ColorspaceConversion_6887f2e74d5145928d4dde174bb981cf_Out_1_Vector3[1];
float _Split_2b8b5bbad0b9449cab8a678b7257b571_B_3_Float = _ColorspaceConversion_6887f2e74d5145928d4dde174bb981cf_Out_1_Vector3[2];
float _Split_2b8b5bbad0b9449cab8a678b7257b571_A_4_Float = 0;
float _Property_07e622f223754e8db9a1c0f144cf4380_Out_0_Float = _Posterization;
float _Multiply_1f3b4aa4180540e6bab2a8a025323a8a_Out_2_Float;
Unity_Multiply_float_float(_Split_2b8b5bbad0b9449cab8a678b7257b571_R_1_Float, _Property_07e622f223754e8db9a1c0f144cf4380_Out_0_Float, _Multiply_1f3b4aa4180540e6bab2a8a025323a8a_Out_2_Float);
float _Floor_c642d1dbc9ee4877b35ab7b2d38aa451_Out_1_Float;
Unity_Floor_float(_Multiply_1f3b4aa4180540e6bab2a8a025323a8a_Out_2_Float, _Floor_c642d1dbc9ee4877b35ab7b2d38aa451_Out_1_Float);
float _Property_2e80548cd7284658a859582545b6f50e_Out_0_Float = _Posterization_Sharpness;
float _Fraction_5a8094c3579a4c5d9cad4520c2b0cd53_Out_1_Float;
Unity_Fraction_float(_Multiply_1f3b4aa4180540e6bab2a8a025323a8a_Out_2_Float, _Fraction_5a8094c3579a4c5d9cad4520c2b0cd53_Out_1_Float);
Bindings_DynamicSCurve_3565967296b1b074e9007137bcb40394_float _DynamicSCurve_e5598a692a07458e80b116ed256a89e8;
half _DynamicSCurve_e5598a692a07458e80b116ed256a89e8_Output_2_Float;
SG_DynamicSCurve_3565967296b1b074e9007137bcb40394_float(_Property_2e80548cd7284658a859582545b6f50e_Out_0_Float, _Fraction_5a8094c3579a4c5d9cad4520c2b0cd53_Out_1_Float, _DynamicSCurve_e5598a692a07458e80b116ed256a89e8, _DynamicSCurve_e5598a692a07458e80b116ed256a89e8_Output_2_Float);
float _Add_a0c65e7457a1437c81294359341c71c8_Out_2_Float;
Unity_Add_float(_Floor_c642d1dbc9ee4877b35ab7b2d38aa451_Out_1_Float, _DynamicSCurve_e5598a692a07458e80b116ed256a89e8_Output_2_Float, _Add_a0c65e7457a1437c81294359341c71c8_Out_2_Float);
float _Property_aab70366cc8c4df6b7a024d6e1337398_Out_0_Float = _Posterization;
float _Divide_0d9855a4588b49d6b8587fe86caf1004_Out_2_Float;
Unity_Divide_float(_Add_a0c65e7457a1437c81294359341c71c8_Out_2_Float, _Property_aab70366cc8c4df6b7a024d6e1337398_Out_0_Float, _Divide_0d9855a4588b49d6b8587fe86caf1004_Out_2_Float);
float _Log_d5b1a70faf044f85b5d12513aff37699_Out_1_Float;
Unity_Log2_float(_Split_2b8b5bbad0b9449cab8a678b7257b571_B_3_Float, _Log_d5b1a70faf044f85b5d12513aff37699_Out_1_Float);
float _Property_42629d56e9b145958e0034bf344ef226_Out_0_Float = _Metallic;
float _Lerp_fd3d6294a8a34ab8bd8d460c6ab37d6c_Out_3_Float;
Unity_Lerp_float(float(1), float(0.3333333), _Property_42629d56e9b145958e0034bf344ef226_Out_0_Float, _Lerp_fd3d6294a8a34ab8bd8d460c6ab37d6c_Out_3_Float);
float _Multiply_f477590b4b5441cf8614bdd0102f5f32_Out_2_Float;
Unity_Multiply_float_float(_Log_d5b1a70faf044f85b5d12513aff37699_Out_1_Float, _Lerp_fd3d6294a8a34ab8bd8d460c6ab37d6c_Out_3_Float, _Multiply_f477590b4b5441cf8614bdd0102f5f32_Out_2_Float);
float _Floor_f42b74c8270a411da0982fd33f20d5e7_Out_1_Float;
Unity_Floor_float(_Multiply_f477590b4b5441cf8614bdd0102f5f32_Out_2_Float, _Floor_f42b74c8270a411da0982fd33f20d5e7_Out_1_Float);
float _Property_b0041d34b8db46bc8dc49539a104dcf1_Out_0_Float = _Transition_Sharpness;
float _Fraction_3ffc6c982b744f51a6871adf86bb6d17_Out_1_Float;
Unity_Fraction_float(_Multiply_f477590b4b5441cf8614bdd0102f5f32_Out_2_Float, _Fraction_3ffc6c982b744f51a6871adf86bb6d17_Out_1_Float);
Bindings_DynamicSCurve_3565967296b1b074e9007137bcb40394_float _DynamicSCurve_3b9f380ef60e4f3a9cc2812aa84ad9f8;
half _DynamicSCurve_3b9f380ef60e4f3a9cc2812aa84ad9f8_Output_2_Float;
SG_DynamicSCurve_3565967296b1b074e9007137bcb40394_float(_Property_b0041d34b8db46bc8dc49539a104dcf1_Out_0_Float, _Fraction_3ffc6c982b744f51a6871adf86bb6d17_Out_1_Float, _DynamicSCurve_3b9f380ef60e4f3a9cc2812aa84ad9f8, _DynamicSCurve_3b9f380ef60e4f3a9cc2812aa84ad9f8_Output_2_Float);
float _Add_5813508d730241179c839276c1892e54_Out_2_Float;
Unity_Add_float(_Floor_f42b74c8270a411da0982fd33f20d5e7_Out_1_Float, _DynamicSCurve_3b9f380ef60e4f3a9cc2812aa84ad9f8_Output_2_Float, _Add_5813508d730241179c839276c1892e54_Out_2_Float);
float _Divide_22314074bf4949c9b861fbcf57045ed9_Out_2_Float;
Unity_Divide_float(_Add_5813508d730241179c839276c1892e54_Out_2_Float, _Lerp_fd3d6294a8a34ab8bd8d460c6ab37d6c_Out_3_Float, _Divide_22314074bf4949c9b861fbcf57045ed9_Out_2_Float);
float _Property_35eb0e2aa90e42ed906d65f1a3bb0d05_Out_0_Float = _Rim_Light;
float3 _ViewVector_adb78a97b2ea44e088f4b7ce40d0e788_Out_0_Vector3;
Unity_ViewVectorWorld_float(_ViewVector_adb78a97b2ea44e088f4b7ce40d0e788_Out_0_Vector3, IN.WorldSpacePosition);
float _DotProduct_01bbb70d17b94183867e005c1726c4ca_Out_2_Float;
Unity_DotProduct_float3(IN.WorldSpaceNormal, _ViewVector_adb78a97b2ea44e088f4b7ce40d0e788_Out_0_Vector3, _DotProduct_01bbb70d17b94183867e005c1726c4ca_Out_2_Float);
float _Arccosine_64537fb734b44dbba3944b8b84b14c77_Out_1_Float;
Unity_Arccosine_float(_DotProduct_01bbb70d17b94183867e005c1726c4ca_Out_2_Float, _Arccosine_64537fb734b44dbba3944b8b84b14c77_Out_1_Float);
float Constant_f8b656ca1af54d90a3ac98731962d541 = 3.141593;
float _Divide_5804454b417d4000b5e575a6c99f4a86_Out_2_Float;
Unity_Divide_float(Constant_f8b656ca1af54d90a3ac98731962d541, float(2), _Divide_5804454b417d4000b5e575a6c99f4a86_Out_2_Float);
float _Divide_e24683ad45714b83bd59841141f1d367_Out_2_Float;
Unity_Divide_float(_Arccosine_64537fb734b44dbba3944b8b84b14c77_Out_1_Float, _Divide_5804454b417d4000b5e575a6c99f4a86_Out_2_Float, _Divide_e24683ad45714b83bd59841141f1d367_Out_2_Float);
float _InverseLerp_800216468ccc4f728e537a04d670b537_Out_3_Float;
Unity_InverseLerp_float(float(0.5), float(0.8), _Divide_e24683ad45714b83bd59841141f1d367_Out_2_Float, _InverseLerp_800216468ccc4f728e537a04d670b537_Out_3_Float);
float _Saturate_79af768e433046d485dd3e7a63f8b39f_Out_1_Float;
Unity_Saturate_float(_InverseLerp_800216468ccc4f728e537a04d670b537_Out_3_Float, _Saturate_79af768e433046d485dd3e7a63f8b39f_Out_1_Float);
float _Multiply_5dbcd77077d141b6895081ed31cddabf_Out_2_Float;
Unity_Multiply_float_float(_Saturate_79af768e433046d485dd3e7a63f8b39f_Out_1_Float, _Saturate_79af768e433046d485dd3e7a63f8b39f_Out_1_Float, _Multiply_5dbcd77077d141b6895081ed31cddabf_Out_2_Float);
float _Split_6d2339d4cb2945c39e9d2d432789b362_R_1_Float = IN.WorldSpaceNormal[0];
float _Split_6d2339d4cb2945c39e9d2d432789b362_G_2_Float = IN.WorldSpaceNormal[1];
float _Split_6d2339d4cb2945c39e9d2d432789b362_B_3_Float = IN.WorldSpaceNormal[2];
float _Split_6d2339d4cb2945c39e9d2d432789b362_A_4_Float = 0;
float _Float_338deda8c30745b5b2a341ffd1b849ef_Out_0_Float = float(2);
float _Multiply_55f5cbcf511146ea8e37e203068e1f2d_Out_2_Float;
Unity_Multiply_float_float(_Split_6d2339d4cb2945c39e9d2d432789b362_G_2_Float, _Float_338deda8c30745b5b2a341ffd1b849ef_Out_0_Float, _Multiply_55f5cbcf511146ea8e37e203068e1f2d_Out_2_Float);
float _Multiply_fea5f8bf00554b0492150da5dea4ff8e_Out_2_Float;
Unity_Multiply_float_float(_Multiply_5dbcd77077d141b6895081ed31cddabf_Out_2_Float, _Multiply_55f5cbcf511146ea8e37e203068e1f2d_Out_2_Float, _Multiply_fea5f8bf00554b0492150da5dea4ff8e_Out_2_Float);
float _Multiply_1fa0fabbd31f4fcc9f2340408b78185e_Out_2_Float;
Unity_Multiply_float_float(_Property_35eb0e2aa90e42ed906d65f1a3bb0d05_Out_0_Float, _Multiply_fea5f8bf00554b0492150da5dea4ff8e_Out_2_Float, _Multiply_1fa0fabbd31f4fcc9f2340408b78185e_Out_2_Float);
float _Add_a58144872ba94e699c6365f9a593891c_Out_2_Float;
Unity_Add_float(_Divide_22314074bf4949c9b861fbcf57045ed9_Out_2_Float, _Multiply_1fa0fabbd31f4fcc9f2340408b78185e_Out_2_Float, _Add_a58144872ba94e699c6365f9a593891c_Out_2_Float);
float _Power_a5916317387c4081aa32d2933570d809_Out_2_Float;
Unity_Power_float(float(2), _Add_a58144872ba94e699c6365f9a593891c_Out_2_Float, _Power_a5916317387c4081aa32d2933570d809_Out_2_Float);
float _Maximum_b7439812414a4be3817cda571c4ec1e2_Out_2_Float;
Unity_Maximum_float(_Power_a5916317387c4081aa32d2933570d809_Out_2_Float, float(0), _Maximum_b7439812414a4be3817cda571c4ec1e2_Out_2_Float);
float4 _Combine_ebb6335325ea4a278687c3cd845f0e6e_RGBA_4_Vector4;
float3 _Combine_ebb6335325ea4a278687c3cd845f0e6e_RGB_5_Vector3;
float2 _Combine_ebb6335325ea4a278687c3cd845f0e6e_RG_6_Vector2;
Unity_Combine_float(_Divide_0d9855a4588b49d6b8587fe86caf1004_Out_2_Float, _Split_2b8b5bbad0b9449cab8a678b7257b571_G_2_Float, _Maximum_b7439812414a4be3817cda571c4ec1e2_Out_2_Float, _Split_2b8b5bbad0b9449cab8a678b7257b571_A_4_Float, _Combine_ebb6335325ea4a278687c3cd845f0e6e_RGBA_4_Vector4, _Combine_ebb6335325ea4a278687c3cd845f0e6e_RGB_5_Vector3, _Combine_ebb6335325ea4a278687c3cd845f0e6e_RG_6_Vector2);
float3 _ColorspaceConversion_3250b73e99a641879c8e577d36c10ad3_Out_1_Vector3;
Unity_ColorspaceConversion_HSV_RGB_float(_Combine_ebb6335325ea4a278687c3cd845f0e6e_RGB_5_Vector3, _ColorspaceConversion_3250b73e99a641879c8e577d36c10ad3_Out_1_Vector3);
float3 _Maximum_1e2393ebc3604d58b11e0e38db091040_Out_2_Vector3;
Unity_Maximum_float3(_ColorspaceConversion_3250b73e99a641879c8e577d36c10ad3_Out_1_Vector3, float3(0, 0, 0), _Maximum_1e2393ebc3604d58b11e0e38db091040_Out_2_Vector3);
Color_2 = _Maximum_1e2393ebc3604d58b11e0e38db091040_Out_2_Vector3;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
description.Position = IN.ObjectSpacePosition;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
float3 BaseColor;
float Alpha;
float AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
float4 _Property_55c5ce2527444284851f451829601335_Out_0_Vector4 = _Color;
UnityTexture2D _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D = UnityBuildTexture2DStructInternal(_Base, sampler_Base, _Base_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.tex, _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.samplerstate, _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
if (_Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4, _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_R_4_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.r;
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_G_5_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.g;
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_B_6_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.b;
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_A_7_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.a;
float4 _Multiply_61f37827eac943e8ae93f89ea0e75526_Out_2_Vector4;
Unity_Multiply_float4_float4(_Property_55c5ce2527444284851f451829601335_Out_0_Vector4, _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4, _Multiply_61f37827eac943e8ae93f89ea0e75526_Out_2_Vector4);
UnityTexture2D _Property_fc20f84db7324d36bceb15e6e11ceecd_Out_0_Texture2D = UnityBuildTexture2DStructInternal(_Normal, sampler_Normal, _Normal_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_fc20f84db7324d36bceb15e6e11ceecd_Out_0_Texture2D.tex, _Property_fc20f84db7324d36bceb15e6e11ceecd_Out_0_Texture2D.samplerstate, _Property_fc20f84db7324d36bceb15e6e11ceecd_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
if (_Property_fc20f84db7324d36bceb15e6e11ceecd_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4, _Property_fc20f84db7324d36bceb15e6e11ceecd_Out_0_Texture2D.hdrDecode);
_SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4);
float _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_R_4_Float = _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4.r;
float _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_G_5_Float = _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4.g;
float _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_B_6_Float = _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4.b;
float _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_A_7_Float = _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4.a;
UnityTexture2D _Property_92e95d909f834786a128db3d4630a44b_Out_0_Texture2D = UnityBuildTexture2DStructInternal(_Metallic_Smoothness, sampler_Metallic_Smoothness, _Metallic_Smoothness_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_92e95d909f834786a128db3d4630a44b_Out_0_Texture2D.tex, _Property_92e95d909f834786a128db3d4630a44b_Out_0_Texture2D.samplerstate, _Property_92e95d909f834786a128db3d4630a44b_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
if (_Property_92e95d909f834786a128db3d4630a44b_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_RGBA_0_Vector4, _Property_92e95d909f834786a128db3d4630a44b_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_R_4_Float = _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_RGBA_0_Vector4.r;
float _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_G_5_Float = _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_RGBA_0_Vector4.g;
float _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_B_6_Float = _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_RGBA_0_Vector4.b;
float _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_A_7_Float = _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_RGBA_0_Vector4.a;
UnityTexture2D _Property_67a0baf82c6944c794901261ce853689_Out_0_Texture2D = UnityBuildTexture2DStructInternal(_Emissive, sampler_Emissive, _Emissive_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_67a0baf82c6944c794901261ce853689_Out_0_Texture2D.tex, _Property_67a0baf82c6944c794901261ce853689_Out_0_Texture2D.samplerstate, _Property_67a0baf82c6944c794901261ce853689_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
if (_Property_67a0baf82c6944c794901261ce853689_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_RGBA_0_Vector4, _Property_67a0baf82c6944c794901261ce853689_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_R_4_Float = _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_RGBA_0_Vector4.r;
float _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_G_5_Float = _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_RGBA_0_Vector4.g;
float _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_B_6_Float = _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_RGBA_0_Vector4.b;
float _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_A_7_Float = _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_RGBA_0_Vector4.a;
float _Property_737a7264eace4aea95a66c4d180a7185_Out_0_Float = _Emissive_Intensity;
float4 _Multiply_1aa7109ad0954efcb2fe516c58411c07_Out_2_Vector4;
Unity_Multiply_float4_float4(_SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_RGBA_0_Vector4, (_Property_737a7264eace4aea95a66c4d180a7185_Out_0_Float.xxxx), _Multiply_1aa7109ad0954efcb2fe516c58411c07_Out_2_Vector4);
float _Property_723bcef9d5144a12a1dca50553bdb967_Out_0_Float = _Transition_Sharpness;
float _Property_fbfc24be29d34dac98d3e99017691876_Out_0_Float = _Posterization;
float _Property_046028dd74834f0aaeb44803d6ad4c72_Out_0_Float = _Posterization_Sharpness;
float _Property_6cbdfa1aaa89402a8ef11aa9addda98f_Out_0_Float = _Rim_Light;
Bindings_CellLightingModel_28d05442c333727418ac448845e1326b_float _CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.WorldSpaceNormal = IN.WorldSpaceNormal;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.TangentSpaceNormal = IN.TangentSpaceNormal;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.WorldSpaceTangent = IN.WorldSpaceTangent;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.ObjectSpacePosition = IN.ObjectSpacePosition;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.WorldSpacePosition = IN.WorldSpacePosition;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.NDCPosition = IN.NDCPosition;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.PixelPosition = IN.PixelPosition;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.uv1 = IN.uv1;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.uv2 = IN.uv2;
float3 _CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2_Color_2_Vector3;
SG_CellLightingModel_28d05442c333727418ac448845e1326b_float((_Multiply_61f37827eac943e8ae93f89ea0e75526_Out_2_Vector4.xyz), (_SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4.xyz), true, _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_R_4_Float, _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_A_7_Float, _Multiply_1aa7109ad0954efcb2fe516c58411c07_Out_2_Vector4, float(1), _Property_723bcef9d5144a12a1dca50553bdb967_Out_0_Float, _Property_fbfc24be29d34dac98d3e99017691876_Out_0_Float, _Property_046028dd74834f0aaeb44803d6ad4c72_Out_0_Float, _Property_6cbdfa1aaa89402a8ef11aa9addda98f_Out_0_Float, _CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2, _CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2_Color_2_Vector3);
surface.BaseColor = _CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2_Color_2_Vector3;
surface.Alpha = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_A_7_Float;
surface.AlphaClipThreshold = float(0.5);
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
#if VFX_USE_GRAPH_VALUES
    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
#endif
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    

    // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
    float3 unnormalizedNormalWS = input.normalWS;
    const float renormFactor = 1.0 / length(unnormalizedNormalWS);

    // use bitangent on the fly like in hdrp
    // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
    float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
    float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);

    output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);

    // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
    // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
    output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
    output.WorldSpaceBiTangent = renormFactor * bitang;

    output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
    output.WorldSpacePosition = input.positionWS;
    output.ObjectSpacePosition = TransformWorldToObject(input.positionWS);
    output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);

    #if UNITY_UV_STARTS_AT_TOP
    output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
    #else
    output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
    #endif

    output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
    output.NDCPosition.y = 1.0f - output.NDCPosition.y;

    output.uv0 = input.texCoord0;
    output.uv1 = input.texCoord1;
    output.uv2 = input.texCoord2;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitGBufferPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "SceneSelectionPass"
    Tags
    {
        "LightMode" = "SceneSelectionPass"
    }

// Render State
Cull Off

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 2.0
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma shader_feature_local_fragment _ _ALPHATEST_ON
#pragma multi_compile_local _ _MAIN_LIGHT_SHADOWS
#pragma multi_compile_local _ _ADDITIONAL_LIGHT_SHADOWS
#pragma multi_compile_local _ _MAIN_LIGHT_SHADOWS_CASCADE
#pragma multi_compile_local _ _SHADOWS_SOFT
#pragma multi_compile_local _ _ADDITIONAL_LIGHTS
#pragma multi_compile_local _ _LIGHTMAP_SHADOW_MIXING
#pragma multi_compile_local _ _SHADOW_MASKS
#pragma multi_compile_local _ _CLUSTER_LIGHT_LOOP
#pragma multi_compile_local _ _REFLECTION_PROBE_ATLAS
#pragma multi_compile_local _ _REFLECTION_PROBE_BOX_PROJECTION
#pragma multi_compile_local _ _REFLECTION_PROBE_BLENDING



// Defines

#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
#define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
#define VARYINGS_NEED_TEXCOORD0
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEPTHONLY
#define SCENESELECTIONPASS 1
#define ALPHA_CLIP_THRESHOLD 1


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float4 uv0;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0 : INTERP0;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.texCoord0.xyzw = input.texCoord0;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
output.texCoord0 = input.texCoord0.xyzw;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
float _Transition_Sharpness;
float _Posterization;
float _Posterization_Sharpness;
float _Rim_Light;
float4 _Base_TexelSize;
float4 _Normal_TexelSize;
float4 _Color;
float4 _Metallic_Smoothness_TexelSize;
float4 _Emissive_TexelSize;
float _Emissive_Intensity;
UNITY_TEXTURE_STREAMING_DEBUG_VARS;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_Base);
SAMPLER(sampler_Base);
TEXTURE2D(_Normal);
SAMPLER(sampler_Normal);
TEXTURE2D(_Metallic_Smoothness);
SAMPLER(sampler_Metallic_Smoothness);
TEXTURE2D(_Emissive);
SAMPLER(sampler_Emissive);

// Graph Includes
// GraphIncludes: <None>

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions
// GraphFunctions: <None>

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
description.Position = IN.ObjectSpacePosition;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
float Alpha;
float AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
UnityTexture2D _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D = UnityBuildTexture2DStructInternal(_Base, sampler_Base, _Base_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.tex, _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.samplerstate, _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
if (_Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4, _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_R_4_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.r;
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_G_5_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.g;
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_B_6_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.b;
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_A_7_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.a;
surface.Alpha = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_A_7_Float;
surface.AlphaClipThreshold = float(0.5);
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
#if VFX_USE_GRAPH_VALUES
    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
#endif
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    






    #if UNITY_UV_STARTS_AT_TOP
    #else
    #endif


    output.uv0 = input.texCoord0;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "ScenePickingPass"
    Tags
    {
        "LightMode" = "Picking"
    }

// Render State
Cull [_Cull]

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 2.0
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma shader_feature_local_fragment _ _ALPHATEST_ON
#pragma multi_compile_local _ _MAIN_LIGHT_SHADOWS
#pragma multi_compile_local _ _ADDITIONAL_LIGHT_SHADOWS
#pragma multi_compile_local _ _MAIN_LIGHT_SHADOWS_CASCADE
#pragma multi_compile_local _ _SHADOWS_SOFT
#pragma multi_compile_local _ _ADDITIONAL_LIGHTS
#pragma multi_compile_local _ _LIGHTMAP_SHADOW_MIXING
#pragma multi_compile_local _ _SHADOW_MASKS
#pragma multi_compile_local _ _CLUSTER_LIGHT_LOOP
#pragma multi_compile_local _ _REFLECTION_PROBE_ATLAS
#pragma multi_compile_local _ _REFLECTION_PROBE_BOX_PROJECTION
#pragma multi_compile_local _ _REFLECTION_PROBE_BLENDING



// Defines

#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_TEXCOORD2
#define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
#define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
#define VARYINGS_NEED_POSITION_WS
#define VARYINGS_NEED_NORMAL_WS
#define VARYINGS_NEED_TANGENT_WS
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_TEXCOORD2
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEPTHONLY
#define SCENEPICKINGPASS 1
#define ALPHA_CLIP_THRESHOLD 1


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 uv2 : TEXCOORD2;
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 positionWS;
 float3 normalWS;
 float4 tangentWS;
 float4 texCoord0;
 float4 texCoord1;
 float4 texCoord2;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float3 WorldSpaceNormal;
 float3 TangentSpaceNormal;
 float3 WorldSpaceTangent;
 float3 WorldSpaceBiTangent;
 float3 WorldSpaceViewDirection;
 float3 ObjectSpacePosition;
 float3 WorldSpacePosition;
 float3 AbsoluteWorldSpacePosition;
 float2 NDCPosition;
 float2 PixelPosition;
 float4 uv0;
 float4 uv1;
 float4 uv2;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float4 tangentWS : INTERP0;
 float4 texCoord0 : INTERP1;
 float4 texCoord1 : INTERP2;
 float4 texCoord2 : INTERP3;
 float3 positionWS : INTERP4;
 float3 normalWS : INTERP5;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.tangentWS.xyzw = input.tangentWS;
output.texCoord0.xyzw = input.texCoord0;
output.texCoord1.xyzw = input.texCoord1;
output.texCoord2.xyzw = input.texCoord2;
output.positionWS.xyz = input.positionWS;
output.normalWS.xyz = input.normalWS;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
output.tangentWS = input.tangentWS.xyzw;
output.texCoord0 = input.texCoord0.xyzw;
output.texCoord1 = input.texCoord1.xyzw;
output.texCoord2 = input.texCoord2.xyzw;
output.positionWS = input.positionWS.xyz;
output.normalWS = input.normalWS.xyz;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
float _Transition_Sharpness;
float _Posterization;
float _Posterization_Sharpness;
float _Rim_Light;
float4 _Base_TexelSize;
float4 _Normal_TexelSize;
float4 _Color;
float4 _Metallic_Smoothness_TexelSize;
float4 _Emissive_TexelSize;
float _Emissive_Intensity;
UNITY_TEXTURE_STREAMING_DEBUG_VARS;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_Base);
SAMPLER(sampler_Base);
TEXTURE2D(_Normal);
SAMPLER(sampler_Normal);
TEXTURE2D(_Metallic_Smoothness);
SAMPLER(sampler_Metallic_Smoothness);
TEXTURE2D(_Emissive);
SAMPLER(sampler_Emissive);

// Graph Includes
#include_with_pragmas "Assets/Art/Shaders/Custom Lighting/Components/Debug/DebugLightingComplexity.hlsl"

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

void Unity_Divide_float(float A, float B, out float Out)
{
    Out = A / B;
}

void Unity_Divide_half(half A, half B, out half Out)
{
    Out = A / B;
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_OneMinus_half(half In, out half Out)
{
    Out = 1 - In;
}

void Unity_Multiply_float_float(float A, float B, out float Out)
{
Out = A * B;
}

void Unity_Multiply_half_half(half A, half B, out half Out)
{
Out = A * B;
}

// unity-custom-func-begin
void ApplyDecals_float(float4 positionCS, float3 baseColor, float3 specularColor, float3 normalWS, float metallic, float smoothness, float occlusion, out float3 baseColorOut, out float3 specularColorOut, out float3 normalWSOut, out float metallicOut, out float smoothnessOut, out float occlusionOut){
#if !defined(SHADERGRAPH_PREVIEW) && defined(_DBUFFER)
	ApplyDecal(positionCS, baseColor, specularColor, normalWS, metallic, occlusion, smoothness);
	baseColorOut = baseColor;
	specularColorOut = specularColor;
	normalWSOut = normalWS;
	metallicOut = metallic;
	occlusionOut = occlusion;
	smoothnessOut = smoothness;
#else
	baseColorOut = baseColor;
	specularColorOut = specularColor;
	normalWSOut = normalWS;
	metallicOut = metallic;
	occlusionOut = occlusion;
	smoothnessOut = smoothness;
#endif
}
// unity-custom-func-end

struct Bindings_ApplyDecals_66e8fc89f7971da4c8964580a0eb9f80_float
{
float2 PixelPosition;
};

void SG_ApplyDecals_66e8fc89f7971da4c8964580a0eb9f80_float(float3 _Base_Color, float3 _NormalWS, float _Metallic, float _Smoothness, float _AmbientOcclusion, Bindings_ApplyDecals_66e8fc89f7971da4c8964580a0eb9f80_float IN, out float3 BaseColor_1, out float3 SpecularColor_2, out float3 NormalWS_3, out float Metallic_4, out float Smoothness_6, out float AmbientOcclusion_5)
{
float4 _ScreenPosition_475ffbde1b774459b0d45276e537a836_Out_0_Vector4 = float4(IN.PixelPosition.xy, 0, 0);
float _Split_ad27d29658ef44f7b6941c97694d6866_R_1_Float = _ScreenPosition_475ffbde1b774459b0d45276e537a836_Out_0_Vector4[0];
float _Split_ad27d29658ef44f7b6941c97694d6866_G_2_Float = _ScreenPosition_475ffbde1b774459b0d45276e537a836_Out_0_Vector4[1];
float _Split_ad27d29658ef44f7b6941c97694d6866_B_3_Float = _ScreenPosition_475ffbde1b774459b0d45276e537a836_Out_0_Vector4[2];
float _Split_ad27d29658ef44f7b6941c97694d6866_A_4_Float = _ScreenPosition_475ffbde1b774459b0d45276e537a836_Out_0_Vector4[3];
float _Divide_3f9fb3b7b5b94d0d8246bbc34aa63f7b_Out_2_Float;
Unity_Divide_float(_Split_ad27d29658ef44f7b6941c97694d6866_G_2_Float, _ScreenParams.y, _Divide_3f9fb3b7b5b94d0d8246bbc34aa63f7b_Out_2_Float);
float _OneMinus_3cfec48ba27f4585a5feb790836dc9dc_Out_1_Float;
Unity_OneMinus_float(_Divide_3f9fb3b7b5b94d0d8246bbc34aa63f7b_Out_2_Float, _OneMinus_3cfec48ba27f4585a5feb790836dc9dc_Out_1_Float);
float _Multiply_a4baed73797c41c1b9631ae9bbddfe12_Out_2_Float;
Unity_Multiply_float_float(_OneMinus_3cfec48ba27f4585a5feb790836dc9dc_Out_1_Float, _ScreenParams.y, _Multiply_a4baed73797c41c1b9631ae9bbddfe12_Out_2_Float);
float2 _Vector2_eed86f79e1de4c188df97eb091955bc5_Out_0_Vector2 = float2(_Split_ad27d29658ef44f7b6941c97694d6866_R_1_Float, _Multiply_a4baed73797c41c1b9631ae9bbddfe12_Out_2_Float);
float3 _Property_6219e38e66a84dddb55188eb0359a8c3_Out_0_Vector3 = _Base_Color;
float3 _Property_f4c37d8281c1497e8dab743349080d88_Out_0_Vector3 = _NormalWS;
float _Property_0826181079c84604befc19a2460f4daa_Out_0_Float = _Metallic;
float _Property_d54a743184cc4f27b93d5f5b239c7b7e_Out_0_Float = _Smoothness;
float _Property_bd6cbdae9db240b9b4ad935655106f79_Out_0_Float = _AmbientOcclusion;
float3 _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_baseColorOut_8_Vector3;
float3 _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_specularColorOut_9_Vector3;
float3 _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_normalWSOut_10_Vector3;
float _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_metallicOut_11_Float;
float _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_smoothnessOut_13_Float;
float _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_occlusionOut_12_Float;
ApplyDecals_float((float4(_Vector2_eed86f79e1de4c188df97eb091955bc5_Out_0_Vector2, 0.0, 1.0)), _Property_6219e38e66a84dddb55188eb0359a8c3_Out_0_Vector3, float3 (0, 0, 0), _Property_f4c37d8281c1497e8dab743349080d88_Out_0_Vector3, _Property_0826181079c84604befc19a2460f4daa_Out_0_Float, _Property_d54a743184cc4f27b93d5f5b239c7b7e_Out_0_Float, _Property_bd6cbdae9db240b9b4ad935655106f79_Out_0_Float, _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_baseColorOut_8_Vector3, _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_specularColorOut_9_Vector3, _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_normalWSOut_10_Vector3, _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_metallicOut_11_Float, _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_smoothnessOut_13_Float, _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_occlusionOut_12_Float);
BaseColor_1 = _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_baseColorOut_8_Vector3;
SpecularColor_2 = _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_specularColorOut_9_Vector3;
NormalWS_3 = _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_normalWSOut_10_Vector3;
Metallic_4 = _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_metallicOut_11_Float;
Smoothness_6 = _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_smoothnessOut_13_Float;
AmbientOcclusion_5 = _ApplyDecalsCustomFunction_181ae7291f3f43ed9e347bab0596980a_occlusionOut_12_Float;
}

// unity-custom-func-begin
void SwitchLightingDebug_float(float3 BaseColorIn, float3 NormalIn, float MetallicIn, float SmoothnessIn, float3 EmissionIn, float AmbientOcclusionIn, float3 positionWS, float3 bakedGI, out float3 BaseColorOut, out float3 NormalOut, out float MetallicOut, out float SmoothnessOut, out float3 EmissionOut, out float AmbientOcclusionOut){
#if !defined(SHADERGRAPH_PREVIEW) && defined(DEBUG_DISPLAY)

[branch] switch(int(_DebugLightingMode))

{

    case 0: //none

		BaseColorOut = BaseColorIn;

		MetallicOut = MetallicIn;

		SmoothnessOut = SmoothnessIn;

		NormalOut = NormalIn;

		EmissionOut = EmissionIn;

		AmbientOcclusionOut = AmbientOcclusionIn;

		break;

    case 1: //SHADOW_CASCADES

		half cascadeIndex = ComputeCascadeIndex(positionWS);

		switch (uint(cascadeIndex))

		{

			case 0: BaseColorOut = kDebugColorShadowCascade0.rgb;break;

			case 1: BaseColorOut = kDebugColorShadowCascade1.rgb;break;

			case 2: BaseColorOut = kDebugColorShadowCascade2.rgb;break;

			case 3: BaseColorOut = kDebugColorShadowCascade3.rgb;break;

			default: BaseColorOut = kDebugColorBlack.rgb;break;

		}

		MetallicOut = MetallicIn;

		SmoothnessOut = SmoothnessIn;

		NormalOut = NormalIn;

		EmissionOut = EmissionIn;

		AmbientOcclusionOut = AmbientOcclusionIn;

		break;

    case 2: //LIGHTING_WITHOUT_NORMAL_MAPS

		BaseColorOut = float3(1,1,1);

		MetallicOut = 0;

		SmoothnessOut = 0;

		NormalOut = float3(0,0,1);

		EmissionOut = float3(0,0,0);

		AmbientOcclusionOut = 1;

		break;

    case 3: //LIGHTING_WITH_NORMAL_MAPS

		BaseColorOut = float3(1,1,1);

		MetallicOut = 0;

		SmoothnessOut = 0;

		NormalOut = NormalIn;

		EmissionOut = float3(0,0,0);

		AmbientOcclusionOut = 1;

		break;

    case 4: //REFLECTIONS

		BaseColorOut = float3(0.1,0.1,0.1);

		MetallicOut = 1;

		SmoothnessOut = 1;

		NormalOut = float3(0,0,1);

		EmissionOut = float3(0,0,0);

		AmbientOcclusionOut = 1;

		break;

    case 5: //REFLECTIONS_WITH_SMOOTHNESS

		BaseColorOut = float3(0.1,0.1,0.1);

		MetallicOut = 1;

		SmoothnessOut = SmoothnessIn;

		NormalOut = NormalIn;

		EmissionOut = float3(0,0,0);

		AmbientOcclusionOut = AmbientOcclusionIn;

		break;

    case 6: //GLOBAL_ILLUM

		BaseColorOut = bakedGI;

		MetallicOut = MetallicIn;

		SmoothnessOut = 0;

		NormalOut = float3(0,0,1);

		EmissionOut = float3(0,0,0);

		AmbientOcclusionOut = 1;

		break;

    default:

		BaseColorOut = BaseColorIn;

		MetallicOut = MetallicIn;

		SmoothnessOut = SmoothnessIn;

		NormalOut = NormalIn;

		EmissionOut = EmissionIn;

		AmbientOcclusionOut = AmbientOcclusionIn;

		break;

}

#else

		BaseColorOut = BaseColorIn;

		MetallicOut = MetallicIn;

		SmoothnessOut = SmoothnessIn;

		NormalOut = NormalIn;

		EmissionOut = EmissionIn;

		AmbientOcclusionOut = AmbientOcclusionIn;

#endif
}
// unity-custom-func-end

struct Bindings_DebugLighting_61e571d2b9ede1240a524a849d20c997_float
{
float3 WorldSpaceNormal;
float3 WorldSpaceTangent;
float3 WorldSpaceBiTangent;
float3 WorldSpacePosition;
float2 PixelPosition;
half4 uv1;
half4 uv2;
};

void SG_DebugLighting_61e571d2b9ede1240a524a849d20c997_float(float3 _Base_Color, float3 _NormalWS, float _Metallic, float _Smoothness, float3 _Emission, float _AmbientOcclusion, Bindings_DebugLighting_61e571d2b9ede1240a524a849d20c997_float IN, out float3 BaseColor_1, out float3 Normal_4, out float Metallic_2, out float Smoothness_3, out float3 Emission_5, out float AmbientOcclusion_6)
{
float3 _Property_501515703e3a4a1dbd19f4ae273add46_Out_0_Vector3 = _Base_Color;
float3 _Property_e5bcb5bf3b62412b8983e3aa1ada8fcd_Out_0_Vector3 = _NormalWS;
float3 _Transform_13c6b1e888d440fd8340d4a7138979ba_Out_1_Vector3;
{
float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
_Transform_13c6b1e888d440fd8340d4a7138979ba_Out_1_Vector3 = TransformWorldToTangent(_Property_e5bcb5bf3b62412b8983e3aa1ada8fcd_Out_0_Vector3.xyz, tangentTransform, true);
}
float _Property_7a450453146043b2b11397a72c325042_Out_0_Float = _Metallic;
float _Property_f0326121e031478a90610d60b8321364_Out_0_Float = _Smoothness;
float3 _Property_491d95b34bb245718ee21bff5fc249cd_Out_0_Vector3 = _Emission;
float _Property_da91a6effd53499db08bb774d5686c68_Out_0_Float = _AmbientOcclusion;
float3 _BakedGI_3f01c30cb8b64e9d9f7fbe474622c7dc_Out_1_Vector3 = SHADERGRAPH_BAKED_GI(IN.WorldSpacePosition, _Property_e5bcb5bf3b62412b8983e3aa1ada8fcd_Out_0_Vector3, IN.PixelPosition.xy, IN.uv1.xy, IN.uv2.xy, true);
float3 _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_BaseColorOut_7_Vector3;
float3 _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_NormalOut_11_Vector3;
float _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_MetallicOut_9_Float;
float _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_SmoothnessOut_10_Float;
float3 _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_EmissionOut_12_Vector3;
float _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_AmbientOcclusionOut_13_Float;
SwitchLightingDebug_float(_Property_501515703e3a4a1dbd19f4ae273add46_Out_0_Vector3, _Transform_13c6b1e888d440fd8340d4a7138979ba_Out_1_Vector3, _Property_7a450453146043b2b11397a72c325042_Out_0_Float, _Property_f0326121e031478a90610d60b8321364_Out_0_Float, _Property_491d95b34bb245718ee21bff5fc249cd_Out_0_Vector3, _Property_da91a6effd53499db08bb774d5686c68_Out_0_Float, IN.WorldSpacePosition, _BakedGI_3f01c30cb8b64e9d9f7fbe474622c7dc_Out_1_Vector3, _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_BaseColorOut_7_Vector3, _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_NormalOut_11_Vector3, _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_MetallicOut_9_Float, _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_SmoothnessOut_10_Float, _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_EmissionOut_12_Vector3, _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_AmbientOcclusionOut_13_Float);
BaseColor_1 = _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_BaseColorOut_7_Vector3;
Normal_4 = _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_NormalOut_11_Vector3;
Metallic_2 = _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_MetallicOut_9_Float;
Smoothness_3 = _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_SmoothnessOut_10_Float;
Emission_5 = _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_EmissionOut_12_Vector3;
AmbientOcclusion_6 = _SwitchLightingDebugCustomFunction_42498302ac764da3bfbfa011ea59470b_AmbientOcclusionOut_13_Float;
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

void Unity_Add_float(float A, float B, out float Out)
{
    Out = A + B;
}

void Unity_Add_half(half A, half B, out half Out)
{
    Out = A + B;
}

void Unity_Reciprocal_float(float In, out float Out)
{
    Out = 1.0/In;
}

void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
{
    Out = pow((1.0 - saturate(dot(normalize(Normal), ViewDir))), Power);
}

void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
{
    Out = lerp(A, B, T);
}

struct Bindings_ReflectanceURP_57a8ea7c8f931c941b2bb57aedc451aa_float
{
float3 WorldSpaceNormal;
float3 WorldSpaceViewDirection;
};

void SG_ReflectanceURP_57a8ea7c8f931c941b2bb57aedc451aa_float(float3 _Base_Color, float3 _NormalWS, bool _NormalWS_3240674a787044a092398b1ca753ad83_IsConnected, float _Metallic, float _Smoothness, float _F0, Bindings_ReflectanceURP_57a8ea7c8f931c941b2bb57aedc451aa_float IN, out float3 Reflectance_1)
{
float _Property_4678b902494b4e1a9b08a8067b7bed85_Out_0_Float = _Smoothness;
float _OneMinus_0aa2823e9b1a4726bd6382418b3e6a87_Out_1_Float;
Unity_OneMinus_float(_Property_4678b902494b4e1a9b08a8067b7bed85_Out_0_Float, _OneMinus_0aa2823e9b1a4726bd6382418b3e6a87_Out_1_Float);
float _Multiply_314f6a0aec0a44538333e69617e91cf9_Out_2_Float;
Unity_Multiply_float_float(_OneMinus_0aa2823e9b1a4726bd6382418b3e6a87_Out_1_Float, _OneMinus_0aa2823e9b1a4726bd6382418b3e6a87_Out_1_Float, _Multiply_314f6a0aec0a44538333e69617e91cf9_Out_2_Float);
float _Add_513724b99c2f4ea2a803e64d80f0c25b_Out_2_Float;
Unity_Add_float(_Multiply_314f6a0aec0a44538333e69617e91cf9_Out_2_Float, float(1), _Add_513724b99c2f4ea2a803e64d80f0c25b_Out_2_Float);
float _Reciprocal_67b338305d0043abb9e7d82dd0f16146_Out_1_Float;
Unity_Reciprocal_float(_Add_513724b99c2f4ea2a803e64d80f0c25b_Out_2_Float, _Reciprocal_67b338305d0043abb9e7d82dd0f16146_Out_1_Float);
float _Property_b67a6773dce34e91ae69bbf282d871cc_Out_0_Float = _F0;
float _Property_703d9ec0a0894a3b965f0ed25a10435b_Out_0_Float = _F0;
float _Add_8ad10875906b4a80872f2b2fb0518183_Out_2_Float;
Unity_Add_float(_Property_4678b902494b4e1a9b08a8067b7bed85_Out_0_Float, _Property_703d9ec0a0894a3b965f0ed25a10435b_Out_0_Float, _Add_8ad10875906b4a80872f2b2fb0518183_Out_2_Float);
float3 _Property_b5d757941bc04f70897cc735055cef09_Out_0_Vector3 = _NormalWS;
bool _Property_b5d757941bc04f70897cc735055cef09_Out_0_Vector3_IsConnected = _NormalWS_3240674a787044a092398b1ca753ad83_IsConnected;
float3 _BranchOnInputConnection_43b8bde55a8a41468ba21d53db128986_Out_3_Vector3 = _Property_b5d757941bc04f70897cc735055cef09_Out_0_Vector3_IsConnected ? _Property_b5d757941bc04f70897cc735055cef09_Out_0_Vector3 : IN.WorldSpaceNormal;
float _FresnelEffect_34b729c62edd4d5f99dc20e2e7d0a7fa_Out_3_Float;
Unity_FresnelEffect_float(_BranchOnInputConnection_43b8bde55a8a41468ba21d53db128986_Out_3_Vector3, IN.WorldSpaceViewDirection, float(4), _FresnelEffect_34b729c62edd4d5f99dc20e2e7d0a7fa_Out_3_Float);
float _Lerp_1cad776e609842c181b8acfaef47c317_Out_3_Float;
Unity_Lerp_float(_Property_b67a6773dce34e91ae69bbf282d871cc_Out_0_Float, _Add_8ad10875906b4a80872f2b2fb0518183_Out_2_Float, _FresnelEffect_34b729c62edd4d5f99dc20e2e7d0a7fa_Out_3_Float, _Lerp_1cad776e609842c181b8acfaef47c317_Out_3_Float);
float _Multiply_0d364d1c231246d981281b868ea74a95_Out_2_Float;
Unity_Multiply_float_float(_Reciprocal_67b338305d0043abb9e7d82dd0f16146_Out_1_Float, _Lerp_1cad776e609842c181b8acfaef47c317_Out_3_Float, _Multiply_0d364d1c231246d981281b868ea74a95_Out_2_Float);
float3 _Property_87ae51a595c24e46ad9ef0f4493231fc_Out_0_Vector3 = _Base_Color;
float _Property_ce0a90815c5046b48dd0564711f2b466_Out_0_Float = _Metallic;
float3 _Lerp_6b4c86a1d5004851a7dba1bacc4fd953_Out_3_Vector3;
Unity_Lerp_float3((_Multiply_0d364d1c231246d981281b868ea74a95_Out_2_Float.xxx), _Property_87ae51a595c24e46ad9ef0f4493231fc_Out_0_Vector3, (_Property_ce0a90815c5046b48dd0564711f2b466_Out_0_Float.xxx), _Lerp_6b4c86a1d5004851a7dba1bacc4fd953_Out_3_Vector3);
Reflectance_1 = _Lerp_6b4c86a1d5004851a7dba1bacc4fd953_Out_3_Vector3;
}

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

void Unity_Multiply_half3_half3(half3 A, half3 B, out half3 Out)
{
Out = A * B;
}

void Unity_Negate_float3(float3 In, out float3 Out)
{
    Out = -1 * In;
}

void Unity_Reflection_float3(float3 In, float3 Normal, out float3 Out)
{
    Out = reflect(In, Normal);
}

// unity-custom-func-begin
void URPReflectionProbe_float(float3 positionWS, float3 reflectVector, float2 normalizedScreenSpaceUV, float roughness, float occlusion, out float3 reflection){
#ifdef SHADERGRAPH_PREVIEW

    reflection = float3(0,0,0);

#else

    reflection = GlossyEnvironmentReflection(reflectVector, positionWS, roughness, occlusion, normalizedScreenSpaceUV);

#endif
}
// unity-custom-func-end

struct Bindings_SampleReflectionProbes_f70e1da6fb6a720439a85a6a2c814a87_float
{
float3 WorldSpaceNormal;
float3 WorldSpaceViewDirection;
float3 WorldSpacePosition;
float2 NDCPosition;
};

void SG_SampleReflectionProbes_f70e1da6fb6a720439a85a6a2c814a87_float(float3 _positionWS, bool _positionWS_d6701bdc1f184a57ac2283491fc460d9_IsConnected, float3 _reflectVector, bool _reflectVector_3e2eb19b69b8469eaf2302c7abc4cbc5_IsConnected, float _smoothness, float _occlusion, Bindings_SampleReflectionProbes_f70e1da6fb6a720439a85a6a2c814a87_float IN, out float3 Out_1)
{
float3 _Property_b993dfa9c8bb4e4ea4f3cb1768e92822_Out_0_Vector3 = _positionWS;
bool _Property_b993dfa9c8bb4e4ea4f3cb1768e92822_Out_0_Vector3_IsConnected = _positionWS_d6701bdc1f184a57ac2283491fc460d9_IsConnected;
float3 _BranchOnInputConnection_8fb583036b0c4313a1ecd93143939f21_Out_3_Vector3 = _Property_b993dfa9c8bb4e4ea4f3cb1768e92822_Out_0_Vector3_IsConnected ? _Property_b993dfa9c8bb4e4ea4f3cb1768e92822_Out_0_Vector3 : IN.WorldSpacePosition;
float3 _Property_27869743c4c14e898d5c15f6fdd4e044_Out_0_Vector3 = _reflectVector;
bool _Property_27869743c4c14e898d5c15f6fdd4e044_Out_0_Vector3_IsConnected = _reflectVector_3e2eb19b69b8469eaf2302c7abc4cbc5_IsConnected;
float3 _Negate_9cf7cea21c5641239fdbcb32480ac39e_Out_1_Vector3;
Unity_Negate_float3(IN.WorldSpaceViewDirection, _Negate_9cf7cea21c5641239fdbcb32480ac39e_Out_1_Vector3);
float3 _Reflection_c8689c494aab4411aadc74299549c6cb_Out_2_Vector3;
Unity_Reflection_float3(_Negate_9cf7cea21c5641239fdbcb32480ac39e_Out_1_Vector3, IN.WorldSpaceNormal, _Reflection_c8689c494aab4411aadc74299549c6cb_Out_2_Vector3);
float3 _BranchOnInputConnection_9600230d09794702a61c1a01f8e842a5_Out_3_Vector3 = _Property_27869743c4c14e898d5c15f6fdd4e044_Out_0_Vector3_IsConnected ? _Property_27869743c4c14e898d5c15f6fdd4e044_Out_0_Vector3 : _Reflection_c8689c494aab4411aadc74299549c6cb_Out_2_Vector3;
float4 _ScreenPosition_270e438746a9466e8aaf01f4903f62fb_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
float _Property_9012e47da801473d8ef85a4092281eb2_Out_0_Float = _smoothness;
float _OneMinus_b2508f25afb44017ba3480edc35cf631_Out_1_Float;
Unity_OneMinus_float(_Property_9012e47da801473d8ef85a4092281eb2_Out_0_Float, _OneMinus_b2508f25afb44017ba3480edc35cf631_Out_1_Float);
float _Property_d602b1723845462cbf00324de1e9e82a_Out_0_Float = _occlusion;
float3 _URPReflectionProbeCustomFunction_7233d098cd214f55baf898d486bfdf4b_reflection_4_Vector3;
URPReflectionProbe_float(_BranchOnInputConnection_8fb583036b0c4313a1ecd93143939f21_Out_3_Vector3, _BranchOnInputConnection_9600230d09794702a61c1a01f8e842a5_Out_3_Vector3, (_ScreenPosition_270e438746a9466e8aaf01f4903f62fb_Out_0_Vector4.xy), _OneMinus_b2508f25afb44017ba3480edc35cf631_Out_1_Float, _Property_d602b1723845462cbf00324de1e9e82a_Out_0_Float, _URPReflectionProbeCustomFunction_7233d098cd214f55baf898d486bfdf4b_reflection_4_Vector3);
Out_1 = _URPReflectionProbeCustomFunction_7233d098cd214f55baf898d486bfdf4b_reflection_4_Vector3;
}

void Unity_Add_float3(float3 A, float3 B, out float3 Out)
{
    Out = A + B;
}

// unity-custom-func-begin
void SSAO_float(float2 normalizedScreenSpaceUV, out float indirectAmbientOcclusion, out float directAmbientOcclusion){
#if defined(_SCREEN_SPACE_OCCLUSION) && !defined(_SURFACE_TYPE_TRANSPARENT) && !defined(SHADERGRAPH_PREVIEW)

    float ssao = saturate(SampleAmbientOcclusion(normalizedScreenSpaceUV) + (1.0 - _AmbientOcclusionParam.x));

    indirectAmbientOcclusion = ssao;

    directAmbientOcclusion = lerp(half(1.0), ssao, _AmbientOcclusionParam.w);

#else

    directAmbientOcclusion = half(1.0);

    indirectAmbientOcclusion = half(1.0);

#endif
}
// unity-custom-func-end

struct Bindings_ScreenSpaceAmbientOcclusion_616a08cdf385c2d4997a5ed9d01e16a8_float
{
float2 NDCPosition;
};

void SG_ScreenSpaceAmbientOcclusion_616a08cdf385c2d4997a5ed9d01e16a8_float(Bindings_ScreenSpaceAmbientOcclusion_616a08cdf385c2d4997a5ed9d01e16a8_float IN, out float indirectAO_1, out float directAO_2)
{
float4 _ScreenPosition_0fdc511287e14fd48ca909caba575383_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
float _SSAOCustomFunction_0f48e52099d04b51a6b1dc52cce50d39_indirectAmbientOcclusion_0_Float;
float _SSAOCustomFunction_0f48e52099d04b51a6b1dc52cce50d39_directAmbientOcclusion_1_Float;
SSAO_float((_ScreenPosition_0fdc511287e14fd48ca909caba575383_Out_0_Vector4.xy), _SSAOCustomFunction_0f48e52099d04b51a6b1dc52cce50d39_indirectAmbientOcclusion_0_Float, _SSAOCustomFunction_0f48e52099d04b51a6b1dc52cce50d39_directAmbientOcclusion_1_Float);
indirectAO_1 = _SSAOCustomFunction_0f48e52099d04b51a6b1dc52cce50d39_indirectAmbientOcclusion_0_Float;
directAO_2 = _SSAOCustomFunction_0f48e52099d04b51a6b1dc52cce50d39_directAmbientOcclusion_1_Float;
}

void Unity_Minimum_float(float A, float B, out float Out)
{
    Out = min(A, B);
};

struct Bindings_AmbientURP_300875fdd653fe340b08ad1547984cf1_float
{
float3 WorldSpaceNormal;
float3 WorldSpaceViewDirection;
float3 WorldSpacePosition;
float2 NDCPosition;
float2 PixelPosition;
half4 uv1;
half4 uv2;
};

void SG_AmbientURP_300875fdd653fe340b08ad1547984cf1_float(float3 _Base_Color, float3 _NormalWS, bool _NormalWS_3a565a44841d4b729f8e86b08d09299c_IsConnected, float _Metallic, float _Smoothness, float3 _Reflectance, float _Ambient_Occlusion, Bindings_AmbientURP_300875fdd653fe340b08ad1547984cf1_float IN, out float3 Ambient_1, out float DirectAO_2)
{
float3 _Property_d72d925c86ff4010a968b702f0972f69_Out_0_Vector3 = _NormalWS;
bool _Property_d72d925c86ff4010a968b702f0972f69_Out_0_Vector3_IsConnected = _NormalWS_3a565a44841d4b729f8e86b08d09299c_IsConnected;
float3 _BranchOnInputConnection_5e35c0fc2eee4cf7ae47da45409fa2a7_Out_3_Vector3 = _Property_d72d925c86ff4010a968b702f0972f69_Out_0_Vector3_IsConnected ? _Property_d72d925c86ff4010a968b702f0972f69_Out_0_Vector3 : IN.WorldSpaceNormal;
float3 _BakedGI_1ac35076ff2349f99fec2cef2550ff2d_Out_1_Vector3 = SHADERGRAPH_BAKED_GI(IN.WorldSpacePosition, _BranchOnInputConnection_5e35c0fc2eee4cf7ae47da45409fa2a7_Out_3_Vector3, IN.PixelPosition.xy, IN.uv1.xy, IN.uv2.xy, true);
float3 _Property_5fb17e215f49424cb9cc9d0806f3f47d_Out_0_Vector3 = _Base_Color;
float _Property_f995d8544fdb448d85ac845c7bdee967_Out_0_Float = _Metallic;
float3 _Lerp_842ba4fcd0cf48a3afa108eecd7d56a8_Out_3_Vector3;
Unity_Lerp_float3(_Property_5fb17e215f49424cb9cc9d0806f3f47d_Out_0_Vector3, float3(0, 0, 0), (_Property_f995d8544fdb448d85ac845c7bdee967_Out_0_Float.xxx), _Lerp_842ba4fcd0cf48a3afa108eecd7d56a8_Out_3_Vector3);
float3 _Multiply_48ca9faac6354eefabc65eeb591f3fc4_Out_2_Vector3;
Unity_Multiply_float3_float3(_BakedGI_1ac35076ff2349f99fec2cef2550ff2d_Out_1_Vector3, _Lerp_842ba4fcd0cf48a3afa108eecd7d56a8_Out_3_Vector3, _Multiply_48ca9faac6354eefabc65eeb591f3fc4_Out_2_Vector3);
float3 _Negate_4f98a1dfbc4d4bd1abe58f406453303f_Out_1_Vector3;
Unity_Negate_float3(IN.WorldSpaceViewDirection, _Negate_4f98a1dfbc4d4bd1abe58f406453303f_Out_1_Vector3);
float3 _Reflection_710a69cb22b745929e6bb9b84d11de2f_Out_2_Vector3;
Unity_Reflection_float3(_Negate_4f98a1dfbc4d4bd1abe58f406453303f_Out_1_Vector3, _BranchOnInputConnection_5e35c0fc2eee4cf7ae47da45409fa2a7_Out_3_Vector3, _Reflection_710a69cb22b745929e6bb9b84d11de2f_Out_2_Vector3);
float _Property_8c3e921b9cb34f7b82d2a71254653c09_Out_0_Float = _Smoothness;
Bindings_SampleReflectionProbes_f70e1da6fb6a720439a85a6a2c814a87_float _SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08;
_SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08.WorldSpaceNormal = IN.WorldSpaceNormal;
_SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
_SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08.WorldSpacePosition = IN.WorldSpacePosition;
_SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08.NDCPosition = IN.NDCPosition;
float3 _SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08_Out_1_Vector3;
SG_SampleReflectionProbes_f70e1da6fb6a720439a85a6a2c814a87_float(half3 (0, 0, 0), false, _Reflection_710a69cb22b745929e6bb9b84d11de2f_Out_2_Vector3, true, _Property_8c3e921b9cb34f7b82d2a71254653c09_Out_0_Float, half(1), _SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08, _SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08_Out_1_Vector3);
float3 _Property_2ddaa58bd1e94d0b8508ce91ad39fa39_Out_0_Vector3 = _Reflectance;
float3 _Multiply_40be6c08ca2f44ef99b6a2b81955d62c_Out_2_Vector3;
Unity_Multiply_float3_float3(_SampleReflectionProbes_50169e69b46a45469255f5e1768e7f08_Out_1_Vector3, _Property_2ddaa58bd1e94d0b8508ce91ad39fa39_Out_0_Vector3, _Multiply_40be6c08ca2f44ef99b6a2b81955d62c_Out_2_Vector3);
float3 _Add_c0a57a54eb8b4419a7e907a65e6556a7_Out_2_Vector3;
Unity_Add_float3(_Multiply_48ca9faac6354eefabc65eeb591f3fc4_Out_2_Vector3, _Multiply_40be6c08ca2f44ef99b6a2b81955d62c_Out_2_Vector3, _Add_c0a57a54eb8b4419a7e907a65e6556a7_Out_2_Vector3);
float _Property_5a996c5d941d46019b3ac5ada526c475_Out_0_Float = _Ambient_Occlusion;
Bindings_ScreenSpaceAmbientOcclusion_616a08cdf385c2d4997a5ed9d01e16a8_float _ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e;
_ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e.NDCPosition = IN.NDCPosition;
half _ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e_indirectAO_1_Float;
half _ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e_directAO_2_Float;
SG_ScreenSpaceAmbientOcclusion_616a08cdf385c2d4997a5ed9d01e16a8_float(_ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e, _ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e_indirectAO_1_Float, _ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e_directAO_2_Float);
float _Minimum_699e1643e9974baa97f6f21c8f949d09_Out_2_Float;
Unity_Minimum_float(_Property_5a996c5d941d46019b3ac5ada526c475_Out_0_Float, _ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e_indirectAO_1_Float, _Minimum_699e1643e9974baa97f6f21c8f949d09_Out_2_Float);
float3 _Multiply_ccaf4dfa5cdb4d9fae7fd92dc7d512da_Out_2_Vector3;
Unity_Multiply_float3_float3(_Add_c0a57a54eb8b4419a7e907a65e6556a7_Out_2_Vector3, (_Minimum_699e1643e9974baa97f6f21c8f949d09_Out_2_Float.xxx), _Multiply_ccaf4dfa5cdb4d9fae7fd92dc7d512da_Out_2_Vector3);
float _Minimum_c4dcab6b18b34dde987e68f86d22aed7_Out_2_Float;
Unity_Minimum_float(_Property_5a996c5d941d46019b3ac5ada526c475_Out_0_Float, _ScreenSpaceAmbientOcclusion_61ac988e39cc4471b438c57e0592da7e_directAO_2_Float, _Minimum_c4dcab6b18b34dde987e68f86d22aed7_Out_2_Float);
Ambient_1 = _Multiply_ccaf4dfa5cdb4d9fae7fd92dc7d512da_Out_2_Vector3;
DirectAO_2 = _Minimum_c4dcab6b18b34dde987e68f86d22aed7_Out_2_Float;
}

// unity-custom-func-begin
void GetMainLightData_float(float3 worldPos, out float3 direction, out float3 color, out float shadowAtten){
#ifdef SHADERGRAPH_PREVIEW
    direction = normalize(float3(-0.7,0.7,-0.7));
    color = float3(1,1,1);
    shadowAtten = 1;
#else
    #if defined(UNIVERSAL_PIPELINE_CORE_INCLUDED)
        float4 shadowCoord = TransformWorldToShadowCoord(worldPos);
        Light mainLight = GetMainLight(shadowCoord);
        direction = mainLight.direction;
        color = mainLight.color;
        shadowAtten = mainLight.shadowAttenuation;
    #else
        direction = normalize(float3(-0.7, 0.7, -0.7));
        color = float3(1, 1, 1);
        shadowAtten = 0;
    #endif
#endif
}
// unity-custom-func-end

// unity-custom-func-begin
void GetMainLightData_half(half3 worldPos, out half3 direction, out half3 color, out half shadowAtten){
#ifdef SHADERGRAPH_PREVIEW
    direction = normalize(float3(-0.7,0.7,-0.7));
    color = float3(1,1,1);
    shadowAtten = 1;
#else
    #if defined(UNIVERSAL_PIPELINE_CORE_INCLUDED)
        float4 shadowCoord = TransformWorldToShadowCoord(worldPos);
        Light mainLight = GetMainLight(shadowCoord);
        direction = mainLight.direction;
        color = mainLight.color;
        shadowAtten = mainLight.shadowAttenuation;
    #else
        direction = normalize(float3(-0.7, 0.7, -0.7));
        color = float3(1, 1, 1);
        shadowAtten = 0;
    #endif
#endif
}
// unity-custom-func-end

struct Bindings_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float
{
float3 AbsoluteWorldSpacePosition;
};

void SG_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float(Bindings_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float IN, out float3 Direction_1, out float3 Color_2, out float ShadowAtten_3)
{
float3 _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_direction_2_Vector3;
float3 _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_color_3_Vector3;
float _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_shadowAtten_5_Float;
GetMainLightData_float(IN.AbsoluteWorldSpacePosition, _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_direction_2_Vector3, _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_color_3_Vector3, _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_shadowAtten_5_Float);
Direction_1 = _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_direction_2_Vector3;
Color_2 = _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_color_3_Vector3;
ShadowAtten_3 = _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_shadowAtten_5_Float;
}

struct Bindings_MainLight_f97aba6a33b86e5498cdd202ba0c9313_half
{
float3 AbsoluteWorldSpacePosition;
};

void SG_MainLight_f97aba6a33b86e5498cdd202ba0c9313_half(Bindings_MainLight_f97aba6a33b86e5498cdd202ba0c9313_half IN, out half3 Direction_1, out half3 Color_2, out half ShadowAtten_3)
{
half3 _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_direction_2_Vector3;
half3 _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_color_3_Vector3;
half _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_shadowAtten_5_Float;
GetMainLightData_half(IN.AbsoluteWorldSpacePosition, _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_direction_2_Vector3, _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_color_3_Vector3, _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_shadowAtten_5_Float);
Direction_1 = _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_direction_2_Vector3;
Color_2 = _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_color_3_Vector3;
ShadowAtten_3 = _GetMainLightDataCustomFunction_70d2891fcf6441078175ae15c3935f14_shadowAtten_5_Float;
}

void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
{
    Out = dot(A, B);
}

void Unity_DotProduct_half3(half3 A, half3 B, out half Out)
{
    Out = dot(A, B);
}

void Unity_Saturate_float(float In, out float Out)
{
    Out = saturate(In);
}

void Unity_Saturate_half(half In, out half Out)
{
    Out = saturate(In);
}

struct Bindings_DiffuseLambert_cb5cb9cef826e9f448011787f0d627b2_half
{
float3 WorldSpaceNormal;
float3 AbsoluteWorldSpacePosition;
};

void SG_DiffuseLambert_cb5cb9cef826e9f448011787f0d627b2_half(half3 _NormalWS, bool _NormalWS_68a7999ae9ea4bfba3702fd95b0d1a14_IsConnected, half3 _LightVector, bool _LightVector_a12354c78b694cc6b2bdddd67d09ccdc_IsConnected, Bindings_DiffuseLambert_cb5cb9cef826e9f448011787f0d627b2_half IN, out half Diffuse_1)
{
half3 _Property_c979bfc9e06b459ca5e503658f2eda27_Out_0_Vector3 = _NormalWS;
bool _Property_c979bfc9e06b459ca5e503658f2eda27_Out_0_Vector3_IsConnected = _NormalWS_68a7999ae9ea4bfba3702fd95b0d1a14_IsConnected;
half3 _BranchOnInputConnection_71cde5ac4ee04aacb1e2544c8017ba47_Out_3_Vector3 = _Property_c979bfc9e06b459ca5e503658f2eda27_Out_0_Vector3_IsConnected ? _Property_c979bfc9e06b459ca5e503658f2eda27_Out_0_Vector3 : IN.WorldSpaceNormal;
half3 _Property_99ccf4aecf59420794efa0951355f7ab_Out_0_Vector3 = _LightVector;
bool _Property_99ccf4aecf59420794efa0951355f7ab_Out_0_Vector3_IsConnected = _LightVector_a12354c78b694cc6b2bdddd67d09ccdc_IsConnected;
Bindings_MainLight_f97aba6a33b86e5498cdd202ba0c9313_half _MainLight_fa0151c045984bcab58e58725bae0709;
_MainLight_fa0151c045984bcab58e58725bae0709.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
half3 _MainLight_fa0151c045984bcab58e58725bae0709_Direction_1_Vector3;
half3 _MainLight_fa0151c045984bcab58e58725bae0709_Color_2_Vector3;
half _MainLight_fa0151c045984bcab58e58725bae0709_ShadowAtten_3_Float;
SG_MainLight_f97aba6a33b86e5498cdd202ba0c9313_half(_MainLight_fa0151c045984bcab58e58725bae0709, _MainLight_fa0151c045984bcab58e58725bae0709_Direction_1_Vector3, _MainLight_fa0151c045984bcab58e58725bae0709_Color_2_Vector3, _MainLight_fa0151c045984bcab58e58725bae0709_ShadowAtten_3_Float);
half3 _BranchOnInputConnection_d18845e766084954af1aa554531c90b9_Out_3_Vector3 = _Property_99ccf4aecf59420794efa0951355f7ab_Out_0_Vector3_IsConnected ? _Property_99ccf4aecf59420794efa0951355f7ab_Out_0_Vector3 : _MainLight_fa0151c045984bcab58e58725bae0709_Direction_1_Vector3;
half _DotProduct_daa979e4f9384944a14a23e079be6a5c_Out_2_Float;
Unity_DotProduct_half3(_BranchOnInputConnection_71cde5ac4ee04aacb1e2544c8017ba47_Out_3_Vector3, _BranchOnInputConnection_d18845e766084954af1aa554531c90b9_Out_3_Vector3, _DotProduct_daa979e4f9384944a14a23e079be6a5c_Out_2_Float);
half _Saturate_4747439b9bfa431293a93646ce71aa12_Out_1_Float;
Unity_Saturate_half(_DotProduct_daa979e4f9384944a14a23e079be6a5c_Out_2_Float, _Saturate_4747439b9bfa431293a93646ce71aa12_Out_1_Float);
Diffuse_1 = _Saturate_4747439b9bfa431293a93646ce71aa12_Out_1_Float;
}

void Unity_Clamp_float(float In, float Min, float Max, out float Out)
{
    Out = clamp(In, Min, Max);
}

void Unity_Normalize_float3(float3 In, out float3 Out)
{
    Out = normalize(In);
}

struct Bindings_HalfAngle_e6f25cf5cc5b2cc4da597068c1610d98_float
{
};

void SG_HalfAngle_e6f25cf5cc5b2cc4da597068c1610d98_float(float3 _viewDir, float3 _lightDir, Bindings_HalfAngle_e6f25cf5cc5b2cc4da597068c1610d98_float IN, out float3 Out_1)
{
float3 _Property_fde52ad74bda46adabbcc34b42b16131_Out_0_Vector3 = _viewDir;
float3 _Property_1dc55a6640574aaf8c04290eb0d5e816_Out_0_Vector3 = _lightDir;
float3 _Add_2a8cf5c52e8c4e3fb8c3f9a87b68b2a2_Out_2_Vector3;
Unity_Add_float3(_Property_fde52ad74bda46adabbcc34b42b16131_Out_0_Vector3, _Property_1dc55a6640574aaf8c04290eb0d5e816_Out_0_Vector3, _Add_2a8cf5c52e8c4e3fb8c3f9a87b68b2a2_Out_2_Vector3);
float3 _Normalize_b3b8196f46224ae3a998bba24956de7f_Out_1_Vector3;
Unity_Normalize_float3(_Add_2a8cf5c52e8c4e3fb8c3f9a87b68b2a2_Out_2_Vector3, _Normalize_b3b8196f46224ae3a998bba24956de7f_Out_1_Vector3);
Out_1 = _Normalize_b3b8196f46224ae3a998bba24956de7f_Out_1_Vector3;
}

void Unity_Subtract_float(float A, float B, out float Out)
{
    Out = A - B;
}

void Unity_Subtract_half(half A, half B, out half Out)
{
    Out = A - B;
}

void Unity_Maximum_float(float A, float B, out float Out)
{
    Out = max(A, B);
}

void Unity_Maximum_half(half A, half B, out half Out)
{
    Out = max(A, B);
}

// unity-custom-func-begin
void ClampHalf_half(half In, out half Out){
// On platforms where half actually means something, the denominator has a risk of overflow
// clamp below was added specifically to "fix" that, but dx compiler (we convert bytecode to metal/gles)
// sees that specularTerm have only non-negative terms, so it skips max(0,..) in clamp (leaving only min(100,...))

Out = In;
#if REAL_IS_HALF
	Out = Out - HALF_MIN;
	Out = clamp(Out, 0.0, 1000.0);// Prevent FP16 overflow on mobiles
#endif
}
// unity-custom-func-end

struct Bindings_SpecularURP_836ccbead8eba604dae19317e6fd4f6f_half
{
float3 WorldSpaceNormal;
float3 WorldSpaceViewDirection;
float3 AbsoluteWorldSpacePosition;
};

void SG_SpecularURP_836ccbead8eba604dae19317e6fd4f6f_half(float3 _NormalWS, bool _NormalWS_5a3c9a3a7faa491894a42d170b5bfeb5_IsConnected, half _Smoothness, half3 _Reflectance, float3 _LightVector, bool _LightVector_3db37b6247094f32bcccc4cb689d525f_IsConnected, Bindings_SpecularURP_836ccbead8eba604dae19317e6fd4f6f_half IN, out half3 Specular_1)
{
half _Property_65663a4adb9d4d15a53c703bd776ed76_Out_0_Float = _Smoothness;
half _OneMinus_6b5b83d6bb3448b4a48ff714eae900b8_Out_1_Float;
Unity_OneMinus_half(_Property_65663a4adb9d4d15a53c703bd776ed76_Out_0_Float, _OneMinus_6b5b83d6bb3448b4a48ff714eae900b8_Out_1_Float);
half _Multiply_0d498c303fa747ca821fcfd6d09f0cac_Out_2_Float;
Unity_Multiply_half_half(_OneMinus_6b5b83d6bb3448b4a48ff714eae900b8_Out_1_Float, _OneMinus_6b5b83d6bb3448b4a48ff714eae900b8_Out_1_Float, _Multiply_0d498c303fa747ca821fcfd6d09f0cac_Out_2_Float);
half _Multiply_58dcb1541dc645ee91419691340a6e24_Out_2_Float;
Unity_Multiply_half_half(_Multiply_0d498c303fa747ca821fcfd6d09f0cac_Out_2_Float, _Multiply_0d498c303fa747ca821fcfd6d09f0cac_Out_2_Float, _Multiply_58dcb1541dc645ee91419691340a6e24_Out_2_Float);
float3 _Property_031663d8c32f41ec8c5aa64dfd664823_Out_0_Vector3 = _LightVector;
bool _Property_031663d8c32f41ec8c5aa64dfd664823_Out_0_Vector3_IsConnected = _LightVector_3db37b6247094f32bcccc4cb689d525f_IsConnected;
Bindings_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float _MainLight_6570bf88718b46ebb6bd80eec408287a;
_MainLight_6570bf88718b46ebb6bd80eec408287a.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
float3 _MainLight_6570bf88718b46ebb6bd80eec408287a_Direction_1_Vector3;
float3 _MainLight_6570bf88718b46ebb6bd80eec408287a_Color_2_Vector3;
float _MainLight_6570bf88718b46ebb6bd80eec408287a_ShadowAtten_3_Float;
SG_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float(_MainLight_6570bf88718b46ebb6bd80eec408287a, _MainLight_6570bf88718b46ebb6bd80eec408287a_Direction_1_Vector3, _MainLight_6570bf88718b46ebb6bd80eec408287a_Color_2_Vector3, _MainLight_6570bf88718b46ebb6bd80eec408287a_ShadowAtten_3_Float);
float3 _BranchOnInputConnection_6a7b13b3cb82474aa187229c3d17a00f_Out_3_Vector3 = _Property_031663d8c32f41ec8c5aa64dfd664823_Out_0_Vector3_IsConnected ? _Property_031663d8c32f41ec8c5aa64dfd664823_Out_0_Vector3 : _MainLight_6570bf88718b46ebb6bd80eec408287a_Direction_1_Vector3;
Bindings_HalfAngle_e6f25cf5cc5b2cc4da597068c1610d98_float _HalfAngle_f48886360d2649d8b7540e6fb3eef669;
float3 _HalfAngle_f48886360d2649d8b7540e6fb3eef669_Out_1_Vector3;
SG_HalfAngle_e6f25cf5cc5b2cc4da597068c1610d98_float(IN.WorldSpaceViewDirection, _BranchOnInputConnection_6a7b13b3cb82474aa187229c3d17a00f_Out_3_Vector3, _HalfAngle_f48886360d2649d8b7540e6fb3eef669, _HalfAngle_f48886360d2649d8b7540e6fb3eef669_Out_1_Vector3);
float3 _Property_801dfbee5fa540ac80af739a98535520_Out_0_Vector3 = _NormalWS;
bool _Property_801dfbee5fa540ac80af739a98535520_Out_0_Vector3_IsConnected = _NormalWS_5a3c9a3a7faa491894a42d170b5bfeb5_IsConnected;
float3 _BranchOnInputConnection_72430741d0e04d2dbf5368b624a090cc_Out_3_Vector3 = _Property_801dfbee5fa540ac80af739a98535520_Out_0_Vector3_IsConnected ? _Property_801dfbee5fa540ac80af739a98535520_Out_0_Vector3 : IN.WorldSpaceNormal;
float _DotProduct_4558c6edcb084d359ac8ee4b2934ea05_Out_2_Float;
Unity_DotProduct_float3(_HalfAngle_f48886360d2649d8b7540e6fb3eef669_Out_1_Vector3, _BranchOnInputConnection_72430741d0e04d2dbf5368b624a090cc_Out_3_Vector3, _DotProduct_4558c6edcb084d359ac8ee4b2934ea05_Out_2_Float);
float _Saturate_23d3962f416c4150a990dcb36b5ecbc4_Out_1_Float;
Unity_Saturate_float(_DotProduct_4558c6edcb084d359ac8ee4b2934ea05_Out_2_Float, _Saturate_23d3962f416c4150a990dcb36b5ecbc4_Out_1_Float);
float _Multiply_0c95bad7699b4ca9a8ce1e6744a02f14_Out_2_Float;
Unity_Multiply_float_float(_Saturate_23d3962f416c4150a990dcb36b5ecbc4_Out_1_Float, _Saturate_23d3962f416c4150a990dcb36b5ecbc4_Out_1_Float, _Multiply_0c95bad7699b4ca9a8ce1e6744a02f14_Out_2_Float);
half _Subtract_c6521ef2abfd4cb6b19d856f80ce6635_Out_2_Float;
Unity_Subtract_half(_Multiply_58dcb1541dc645ee91419691340a6e24_Out_2_Float, half(1), _Subtract_c6521ef2abfd4cb6b19d856f80ce6635_Out_2_Float);
float _Multiply_428fcfebb99e43a2846be57068218dd1_Out_2_Float;
Unity_Multiply_float_float(_Multiply_0c95bad7699b4ca9a8ce1e6744a02f14_Out_2_Float, _Subtract_c6521ef2abfd4cb6b19d856f80ce6635_Out_2_Float, _Multiply_428fcfebb99e43a2846be57068218dd1_Out_2_Float);
float _Add_0670771ec2f54d57ab3ba72f8cf8563e_Out_2_Float;
Unity_Add_float(_Multiply_428fcfebb99e43a2846be57068218dd1_Out_2_Float, float(1.00001), _Add_0670771ec2f54d57ab3ba72f8cf8563e_Out_2_Float);
half _Multiply_6de38edabacc4727a961face8b45eec7_Out_2_Float;
Unity_Multiply_half_half(_Add_0670771ec2f54d57ab3ba72f8cf8563e_Out_2_Float, _Add_0670771ec2f54d57ab3ba72f8cf8563e_Out_2_Float, _Multiply_6de38edabacc4727a961face8b45eec7_Out_2_Float);
half _DotProduct_f2e2c0a55fa749c6bcac3befdaf5cc9e_Out_2_Float;
Unity_DotProduct_half3(_HalfAngle_f48886360d2649d8b7540e6fb3eef669_Out_1_Vector3, _MainLight_6570bf88718b46ebb6bd80eec408287a_Direction_1_Vector3, _DotProduct_f2e2c0a55fa749c6bcac3befdaf5cc9e_Out_2_Float);
half _Saturate_b1a77817dddf4a70af2dbe91af25aa03_Out_1_Float;
Unity_Saturate_half(_DotProduct_f2e2c0a55fa749c6bcac3befdaf5cc9e_Out_2_Float, _Saturate_b1a77817dddf4a70af2dbe91af25aa03_Out_1_Float);
half _Multiply_d16da90e46294009bbf058077207a283_Out_2_Float;
Unity_Multiply_half_half(_Saturate_b1a77817dddf4a70af2dbe91af25aa03_Out_1_Float, _Saturate_b1a77817dddf4a70af2dbe91af25aa03_Out_1_Float, _Multiply_d16da90e46294009bbf058077207a283_Out_2_Float);
half _Maximum_d4132949baac4389abbeb7cf75a9450d_Out_2_Float;
Unity_Maximum_half(half(0.1), _Multiply_d16da90e46294009bbf058077207a283_Out_2_Float, _Maximum_d4132949baac4389abbeb7cf75a9450d_Out_2_Float);
half _Multiply_fd05dbe22b3b449c83455ee11e655ceb_Out_2_Float;
Unity_Multiply_half_half(_Multiply_6de38edabacc4727a961face8b45eec7_Out_2_Float, _Maximum_d4132949baac4389abbeb7cf75a9450d_Out_2_Float, _Multiply_fd05dbe22b3b449c83455ee11e655ceb_Out_2_Float);
half _Multiply_93304cb0ca10459185664116606ab5f3_Out_2_Float;
Unity_Multiply_half_half(_Multiply_0d498c303fa747ca821fcfd6d09f0cac_Out_2_Float, 4, _Multiply_93304cb0ca10459185664116606ab5f3_Out_2_Float);
half _Add_f5a8f83262b84718853bbbadf886aa8d_Out_2_Float;
Unity_Add_half(_Multiply_93304cb0ca10459185664116606ab5f3_Out_2_Float, half(2), _Add_f5a8f83262b84718853bbbadf886aa8d_Out_2_Float);
half _Multiply_ceffc5e723e346189be38ea16239f587_Out_2_Float;
Unity_Multiply_half_half(_Multiply_fd05dbe22b3b449c83455ee11e655ceb_Out_2_Float, _Add_f5a8f83262b84718853bbbadf886aa8d_Out_2_Float, _Multiply_ceffc5e723e346189be38ea16239f587_Out_2_Float);
half _Divide_2589d64ba94841aa933a4e5af66460cf_Out_2_Float;
Unity_Divide_half(_Multiply_58dcb1541dc645ee91419691340a6e24_Out_2_Float, _Multiply_ceffc5e723e346189be38ea16239f587_Out_2_Float, _Divide_2589d64ba94841aa933a4e5af66460cf_Out_2_Float);
half _ClampHalfCustomFunction_ff6472ae9f514325a4b9e1f9a0f7a70f_Out_1_Float;
ClampHalf_half(_Divide_2589d64ba94841aa933a4e5af66460cf_Out_2_Float, _ClampHalfCustomFunction_ff6472ae9f514325a4b9e1f9a0f7a70f_Out_1_Float);
half3 _Property_a62a42c671e64b02b9f980de350ccbd3_Out_0_Vector3 = _Reflectance;
half3 _Multiply_db0b4127db554affba0f41edae5085ce_Out_2_Vector3;
Unity_Multiply_half3_half3((_ClampHalfCustomFunction_ff6472ae9f514325a4b9e1f9a0f7a70f_Out_1_Float.xxx), _Property_a62a42c671e64b02b9f980de350ccbd3_Out_0_Vector3, _Multiply_db0b4127db554affba0f41edae5085ce_Out_2_Vector3);
Specular_1 = _Multiply_db0b4127db554affba0f41edae5085ce_Out_2_Vector3;
}

// unity-custom-func-begin
void AddAdditionalLights_float(float Smoothness, float3 WorldPosition, float3 WorldNormal, float3 WorldView, float MainDiffuse, float3 MainSpecular, float3 MainColor, float3 Reflectance, float2 ScreenPosition, out float Diffuse, out float3 Specular, out float3 Color){
Diffuse = MainDiffuse;

Specular = MainSpecular;

Color = MainColor * (MainDiffuse + MainSpecular);



#ifndef SHADERGRAPH_PREVIEW

    

    uint pixelLightCount = GetAdditionalLightsCount();

    half Roughness = pow(1 - Smoothness, 2);

    half Roughness2 = Roughness * Roughness;

	half Roughness2Minus1 = Roughness2 - 1;

	half normalizationTerm = (Roughness * half(4.0) + half(2.0));



#if USE_CLUSTER_LIGHT_LOOP

    // for Foward+ LIGHT_LOOP_BEGIN macro uses inputData.normalizedScreenSpaceUV and inputData.positionWS

    InputData inputData = (InputData)0;



    inputData.normalizedScreenSpaceUV = ScreenPosition;

    inputData.positionWS = WorldPosition;

#endif



    LIGHT_LOOP_BEGIN(pixelLightCount)

		// Call the URP additional light algorithm. This will not calculate shadows, since we don't pass a shadow mask value

		Light light = GetAdditionalLight(lightIndex, WorldPosition);

		// Manually set the shadow attenuation by calculating realtime shadows

		light.shadowAttenuation = AdditionalLightRealtimeShadow(lightIndex, WorldPosition, light.direction);

        #if defined(_LIGHT_COOKIES)

            float3 cookieColor = SampleAdditionalLightCookie(lightIndex, WorldPosition);

            light.color *= cookieColor;

        #endif

        float NdotL = saturate(dot(WorldNormal, light.direction));

        float atten = light.distanceAttenuation * light.shadowAttenuation;

        float thisDiffuse = NdotL * atten;

        //DirectBRDFSpecular



        float3 lightDirectionWSFloat3 = float3(light.direction);

        float3 halfDir = SafeNormalize(lightDirectionWSFloat3 + float3(WorldView));

        float NoH = saturate(dot(float3(WorldNormal), halfDir));

        half LoH = half(saturate(dot(lightDirectionWSFloat3, halfDir)));

        float d = NoH * NoH * Roughness2Minus1 + 1.00001f;

        half LoH2 = LoH * LoH;

        half spec = Roughness2 / ((d * d) * max(0.1h, LoH2) * normalizationTerm);

        #if REAL_IS_HALF

            spec = spec - HALF_MIN;

            spec = clamp(spec, 0.0, 1000.0);

        #endif		

        float3 thisSpecular = spec * Reflectance * NdotL * atten;



        Diffuse += thisDiffuse;

        Specular += thisSpecular;



        Color += light.color * (thisDiffuse + thisSpecular);

    LIGHT_LOOP_END

    float total = Diffuse + dot(Specular, float3(0.333, 0.333, 0.333));

    Color = total <= 0 ? MainColor : Color / total;

#endif
}
// unity-custom-func-end

struct Bindings_AdditionalLightsURP_97b36dcc0c1df064bab3b4b47d231089_float
{
float3 WorldSpaceNormal;
float3 WorldSpaceViewDirection;
float3 AbsoluteWorldSpacePosition;
float2 NDCPosition;
};

void SG_AdditionalLightsURP_97b36dcc0c1df064bab3b4b47d231089_float(float _MainLightDiffuse, float3 _MainLightSpecular, float3 _MainLightColor, float3 _NormalWS, bool _NormalWS_70cbf5ac6da04bf6bd87eb71ccb7c48d_IsConnected, float _Smoothness, float3 _Reflectance, Bindings_AdditionalLightsURP_97b36dcc0c1df064bab3b4b47d231089_float IN, out float Diffuse_1, out float3 Specular_2, out float3 Color_3)
{
float _Property_b9f05025da4f4857a7b1b6f56259a629_Out_0_Float = _Smoothness;
float3 _Property_3e48999a139848e6ab2e955c61810b83_Out_0_Vector3 = _NormalWS;
bool _Property_3e48999a139848e6ab2e955c61810b83_Out_0_Vector3_IsConnected = _NormalWS_70cbf5ac6da04bf6bd87eb71ccb7c48d_IsConnected;
float3 _BranchOnInputConnection_d869e3d8654b48a491de945ad8af6301_Out_3_Vector3 = _Property_3e48999a139848e6ab2e955c61810b83_Out_0_Vector3_IsConnected ? _Property_3e48999a139848e6ab2e955c61810b83_Out_0_Vector3 : IN.WorldSpaceNormal;
float _Property_25880f0697234954b8dc6ef11af3752d_Out_0_Float = _MainLightDiffuse;
float3 _Property_1e29ad89226c4d84a936fe7530839aef_Out_0_Vector3 = _MainLightSpecular;
float3 _Property_ac790fc8215b4b3d8851855d2153960d_Out_0_Vector3 = _MainLightColor;
float3 _Property_eea8eda455d44ae7b30c65f80baac806_Out_0_Vector3 = _Reflectance;
float4 _ScreenPosition_c15512235d2f46b4b03bc2c4a1be229d_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
float _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Diffuse_7_Float;
float3 _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Specular_8_Vector3;
float3 _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Color_9_Vector3;
AddAdditionalLights_float(_Property_b9f05025da4f4857a7b1b6f56259a629_Out_0_Float, IN.AbsoluteWorldSpacePosition, _BranchOnInputConnection_d869e3d8654b48a491de945ad8af6301_Out_3_Vector3, IN.WorldSpaceViewDirection, _Property_25880f0697234954b8dc6ef11af3752d_Out_0_Float, _Property_1e29ad89226c4d84a936fe7530839aef_Out_0_Vector3, _Property_ac790fc8215b4b3d8851855d2153960d_Out_0_Vector3, _Property_eea8eda455d44ae7b30c65f80baac806_Out_0_Vector3, (_ScreenPosition_c15512235d2f46b4b03bc2c4a1be229d_Out_0_Vector4.xy), _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Diffuse_7_Float, _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Specular_8_Vector3, _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Color_9_Vector3);
Diffuse_1 = _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Diffuse_7_Float;
Specular_2 = _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Specular_8_Vector3;
Color_3 = _AddAdditionalLightsCustomFunction_af7e463337fa464994ef4fefeb1ef2b0_Color_9_Vector3;
}

void Unity_Fog_float(out float4 Color, out float Density, float3 Position)
{
    SHADERGRAPH_FOG(Position, Color, Density);
}

struct Bindings_Fog_286ae83400099a24bba6faf005588be7_float
{
float3 ObjectSpacePosition;
};

void SG_Fog_286ae83400099a24bba6faf005588be7_float(float3 _In, Bindings_Fog_286ae83400099a24bba6faf005588be7_float IN, out float3 Out_1)
{
float3 _Property_626923dc627443639da97776de7dcc22_Out_0_Vector3 = _In;
float4 _Fog_acabe3c84c9549f3880ce7d106150576_Color_0_Vector4;
float _Fog_acabe3c84c9549f3880ce7d106150576_Density_1_Float;
Unity_Fog_float(_Fog_acabe3c84c9549f3880ce7d106150576_Color_0_Vector4, _Fog_acabe3c84c9549f3880ce7d106150576_Density_1_Float, IN.ObjectSpacePosition);
float3 _Lerp_9cfca9aa08c7423bab62b39a01237d64_Out_3_Vector3;
Unity_Lerp_float3(_Property_626923dc627443639da97776de7dcc22_Out_0_Vector3, (_Fog_acabe3c84c9549f3880ce7d106150576_Color_0_Vector4.xyz), (_Fog_acabe3c84c9549f3880ce7d106150576_Density_1_Float.xxx), _Lerp_9cfca9aa08c7423bab62b39a01237d64_Out_3_Vector3);
Out_1 = _Lerp_9cfca9aa08c7423bab62b39a01237d64_Out_3_Vector3;
}

struct Bindings_LightURP_17836dba1a675e246923104447b19cbd_float
{
float3 WorldSpaceNormal;
float3 WorldSpaceTangent;
float3 WorldSpaceBiTangent;
float3 WorldSpaceViewDirection;
float3 ObjectSpacePosition;
float3 WorldSpacePosition;
float3 AbsoluteWorldSpacePosition;
float2 NDCPosition;
float2 PixelPosition;
half4 uv1;
half4 uv2;
};

void SG_LightURP_17836dba1a675e246923104447b19cbd_float(float3 _Base_Color, float3 _Normal, bool _Normal_e1611e545480449d80aa5a0e7c2b63c4_IsConnected, float _Metallic, float _Smoothness, float _Ambient_Occlusion, float _Micro_Occlusion, Bindings_LightURP_17836dba1a675e246923104447b19cbd_float IN, out float3 Lit_1)
{
float3 _Property_6ed4205d0e494d9fbe20d17c4850dd01_Out_0_Vector3 = _Base_Color;
float3 _Property_625b0af59fbf4eb3846fcad626b34ca0_Out_0_Vector3 = _Base_Color;
float3 _Property_dbe43d633d7c40db91271fec54a22ee2_Out_0_Vector3 = _Normal;
bool _Property_dbe43d633d7c40db91271fec54a22ee2_Out_0_Vector3_IsConnected = _Normal_e1611e545480449d80aa5a0e7c2b63c4_IsConnected;
float3 _Transform_e8dcf06340124e7d8017300bc4dcb2c9_Out_1_Vector3;
{
float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
_Transform_e8dcf06340124e7d8017300bc4dcb2c9_Out_1_Vector3 = TransformTangentToWorld(_Property_dbe43d633d7c40db91271fec54a22ee2_Out_0_Vector3.xyz, tangentTransform, true);
}
float3 _BranchOnInputConnection_b3c5feecd28b43998390fb43ac1592b1_Out_3_Vector3 = _Property_dbe43d633d7c40db91271fec54a22ee2_Out_0_Vector3_IsConnected ? _Transform_e8dcf06340124e7d8017300bc4dcb2c9_Out_1_Vector3 : IN.WorldSpaceNormal;
float _Property_c5baaae739ad42b392a1b796ed36950b_Out_0_Float = _Metallic;
float _Property_ac10139ecedb4301b4595fa5b13c00b8_Out_0_Float = _Smoothness;
float3 _Property_8ab90e0aaf6a448083ce06c935d78437_Out_0_Vector3 = _Base_Color;
float _Property_2218b1e4c2a849809a373d68812e2b9e_Out_0_Float = _Metallic;
float _Property_732cd42e013c4b79b1d2ba9bc0bad8a6_Out_0_Float = _Smoothness;
float _Property_fdd3b516f2aa41159cf35a16e66b941f_Out_0_Float = _Micro_Occlusion;
float _Multiply_27f0b930a5b849e48209ca66e62866fe_Out_2_Float;
Unity_Multiply_float_float(_Property_fdd3b516f2aa41159cf35a16e66b941f_Out_0_Float, 0.5, _Multiply_27f0b930a5b849e48209ca66e62866fe_Out_2_Float);
float _Lerp_abfa5aa3eaeb4132b82e92eea93328aa_Out_3_Float;
Unity_Lerp_float(float(0), float(0.08), _Multiply_27f0b930a5b849e48209ca66e62866fe_Out_2_Float, _Lerp_abfa5aa3eaeb4132b82e92eea93328aa_Out_3_Float);
Bindings_ReflectanceURP_57a8ea7c8f931c941b2bb57aedc451aa_float _ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d;
_ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d.WorldSpaceNormal = IN.WorldSpaceNormal;
_ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
half3 _ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d_Reflectance_1_Vector3;
SG_ReflectanceURP_57a8ea7c8f931c941b2bb57aedc451aa_float(_Property_8ab90e0aaf6a448083ce06c935d78437_Out_0_Vector3, _BranchOnInputConnection_b3c5feecd28b43998390fb43ac1592b1_Out_3_Vector3, true, _Property_2218b1e4c2a849809a373d68812e2b9e_Out_0_Float, _Property_732cd42e013c4b79b1d2ba9bc0bad8a6_Out_0_Float, _Lerp_abfa5aa3eaeb4132b82e92eea93328aa_Out_3_Float, _ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d, _ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d_Reflectance_1_Vector3);
float _Property_0a056a259612407e813453c548affc50_Out_0_Float = _Ambient_Occlusion;
float _Split_065289545529474a93092a5b161c8bd9_R_1_Float = _Property_dbe43d633d7c40db91271fec54a22ee2_Out_0_Vector3[0];
float _Split_065289545529474a93092a5b161c8bd9_G_2_Float = _Property_dbe43d633d7c40db91271fec54a22ee2_Out_0_Vector3[1];
float _Split_065289545529474a93092a5b161c8bd9_B_3_Float = _Property_dbe43d633d7c40db91271fec54a22ee2_Out_0_Vector3[2];
float _Split_065289545529474a93092a5b161c8bd9_A_4_Float = 0;
float _FresnelEffect_66e2f70f47b04f11b7e25a61d65634e3_Out_3_Float;
Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, float(1), _FresnelEffect_66e2f70f47b04f11b7e25a61d65634e3_Out_3_Float);
float _Lerp_e6a5bc336b4d4fa48faf4eabd1b187b7_Out_3_Float;
Unity_Lerp_float(_Split_065289545529474a93092a5b161c8bd9_B_3_Float, float(1), _FresnelEffect_66e2f70f47b04f11b7e25a61d65634e3_Out_3_Float, _Lerp_e6a5bc336b4d4fa48faf4eabd1b187b7_Out_3_Float);
float _Multiply_2f54e3d54d4542f989d1875f64f31280_Out_2_Float;
Unity_Multiply_float_float(_Property_0a056a259612407e813453c548affc50_Out_0_Float, _Lerp_e6a5bc336b4d4fa48faf4eabd1b187b7_Out_3_Float, _Multiply_2f54e3d54d4542f989d1875f64f31280_Out_2_Float);
Bindings_AmbientURP_300875fdd653fe340b08ad1547984cf1_float _AmbientURP_46e1712500da4aae848bd5b24a05f29f;
_AmbientURP_46e1712500da4aae848bd5b24a05f29f.WorldSpaceNormal = IN.WorldSpaceNormal;
_AmbientURP_46e1712500da4aae848bd5b24a05f29f.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
_AmbientURP_46e1712500da4aae848bd5b24a05f29f.WorldSpacePosition = IN.WorldSpacePosition;
_AmbientURP_46e1712500da4aae848bd5b24a05f29f.NDCPosition = IN.NDCPosition;
_AmbientURP_46e1712500da4aae848bd5b24a05f29f.PixelPosition = IN.PixelPosition;
_AmbientURP_46e1712500da4aae848bd5b24a05f29f.uv1 = IN.uv1;
_AmbientURP_46e1712500da4aae848bd5b24a05f29f.uv2 = IN.uv2;
half3 _AmbientURP_46e1712500da4aae848bd5b24a05f29f_Ambient_1_Vector3;
half _AmbientURP_46e1712500da4aae848bd5b24a05f29f_DirectAO_2_Float;
SG_AmbientURP_300875fdd653fe340b08ad1547984cf1_float(_Property_625b0af59fbf4eb3846fcad626b34ca0_Out_0_Vector3, _BranchOnInputConnection_b3c5feecd28b43998390fb43ac1592b1_Out_3_Vector3, true, _Property_c5baaae739ad42b392a1b796ed36950b_Out_0_Float, _Property_ac10139ecedb4301b4595fa5b13c00b8_Out_0_Float, _ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d_Reflectance_1_Vector3, _Multiply_2f54e3d54d4542f989d1875f64f31280_Out_2_Float, _AmbientURP_46e1712500da4aae848bd5b24a05f29f, _AmbientURP_46e1712500da4aae848bd5b24a05f29f_Ambient_1_Vector3, _AmbientURP_46e1712500da4aae848bd5b24a05f29f_DirectAO_2_Float);
float3 _Multiply_a9decac7cda34291a6910c4cd9ad2700_Out_2_Vector3;
Unity_Multiply_float3_float3(_Property_6ed4205d0e494d9fbe20d17c4850dd01_Out_0_Vector3, (_AmbientURP_46e1712500da4aae848bd5b24a05f29f_DirectAO_2_Float.xxx), _Multiply_a9decac7cda34291a6910c4cd9ad2700_Out_2_Vector3);
float _Property_27a5774949ff4e6c9d8808560c39bc95_Out_0_Float = _Metallic;
float3 _Lerp_7894dcaa210343cc83783b010da9c85c_Out_3_Vector3;
Unity_Lerp_float3(_Multiply_a9decac7cda34291a6910c4cd9ad2700_Out_2_Vector3, float3(0, 0, 0), (_Property_27a5774949ff4e6c9d8808560c39bc95_Out_0_Float.xxx), _Lerp_7894dcaa210343cc83783b010da9c85c_Out_3_Vector3);
Bindings_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float _MainLight_d918d0814080438585a810ba0b8afeb4;
_MainLight_d918d0814080438585a810ba0b8afeb4.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
half3 _MainLight_d918d0814080438585a810ba0b8afeb4_Direction_1_Vector3;
half3 _MainLight_d918d0814080438585a810ba0b8afeb4_Color_2_Vector3;
half _MainLight_d918d0814080438585a810ba0b8afeb4_ShadowAtten_3_Float;
SG_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float(_MainLight_d918d0814080438585a810ba0b8afeb4, _MainLight_d918d0814080438585a810ba0b8afeb4_Direction_1_Vector3, _MainLight_d918d0814080438585a810ba0b8afeb4_Color_2_Vector3, _MainLight_d918d0814080438585a810ba0b8afeb4_ShadowAtten_3_Float);
Bindings_DiffuseLambert_cb5cb9cef826e9f448011787f0d627b2_half _DiffuseLambert_7f9e988376a2438ebc87097469e065d3;
_DiffuseLambert_7f9e988376a2438ebc87097469e065d3.WorldSpaceNormal = IN.WorldSpaceNormal;
_DiffuseLambert_7f9e988376a2438ebc87097469e065d3.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
half _DiffuseLambert_7f9e988376a2438ebc87097469e065d3_Diffuse_1_Float;
SG_DiffuseLambert_cb5cb9cef826e9f448011787f0d627b2_half(_BranchOnInputConnection_b3c5feecd28b43998390fb43ac1592b1_Out_3_Vector3, true, _MainLight_d918d0814080438585a810ba0b8afeb4_Direction_1_Vector3, true, _DiffuseLambert_7f9e988376a2438ebc87097469e065d3, _DiffuseLambert_7f9e988376a2438ebc87097469e065d3_Diffuse_1_Float);
float _Property_a888856c392c4ddfbc144ff5ed452e65_Out_0_Float = _Smoothness;
float _Clamp_6b8538ec3747440bbd39832354f4c497_Out_3_Float;
Unity_Clamp_float(_Property_a888856c392c4ddfbc144ff5ed452e65_Out_0_Float, float(0), float(0.94), _Clamp_6b8538ec3747440bbd39832354f4c497_Out_3_Float);
Bindings_SpecularURP_836ccbead8eba604dae19317e6fd4f6f_half _SpecularURP_bb88623835294209a6f5bbddb1ba7f22;
_SpecularURP_bb88623835294209a6f5bbddb1ba7f22.WorldSpaceNormal = IN.WorldSpaceNormal;
_SpecularURP_bb88623835294209a6f5bbddb1ba7f22.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
_SpecularURP_bb88623835294209a6f5bbddb1ba7f22.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
half3 _SpecularURP_bb88623835294209a6f5bbddb1ba7f22_Specular_1_Vector3;
SG_SpecularURP_836ccbead8eba604dae19317e6fd4f6f_half(_BranchOnInputConnection_b3c5feecd28b43998390fb43ac1592b1_Out_3_Vector3, true, _Clamp_6b8538ec3747440bbd39832354f4c497_Out_3_Float, _ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d_Reflectance_1_Vector3, _MainLight_d918d0814080438585a810ba0b8afeb4_Direction_1_Vector3, true, _SpecularURP_bb88623835294209a6f5bbddb1ba7f22, _SpecularURP_bb88623835294209a6f5bbddb1ba7f22_Specular_1_Vector3);
half3 _Multiply_610f130d22274970bc454dfea38393cd_Out_2_Vector3;
Unity_Multiply_half3_half3((_DiffuseLambert_7f9e988376a2438ebc87097469e065d3_Diffuse_1_Float.xxx), _SpecularURP_bb88623835294209a6f5bbddb1ba7f22_Specular_1_Vector3, _Multiply_610f130d22274970bc454dfea38393cd_Out_2_Vector3);
Bindings_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float _MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e;
_MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
half3 _MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e_Direction_1_Vector3;
half3 _MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e_Color_2_Vector3;
half _MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e_ShadowAtten_3_Float;
SG_MainLight_f97aba6a33b86e5498cdd202ba0c9313_float(_MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e, _MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e_Direction_1_Vector3, _MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e_Color_2_Vector3, _MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e_ShadowAtten_3_Float);
float3 _Multiply_9545e2014858428792b92c57dd77e45c_Out_2_Vector3;
Unity_Multiply_float3_float3(_MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e_Color_2_Vector3, (_MainLight_7a0edc4a8be9421ea8d3ff96cbc83a8e_ShadowAtten_3_Float.xxx), _Multiply_9545e2014858428792b92c57dd77e45c_Out_2_Vector3);
Bindings_AdditionalLightsURP_97b36dcc0c1df064bab3b4b47d231089_float _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd;
_AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd.WorldSpaceNormal = IN.WorldSpaceNormal;
_AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
_AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
_AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd.NDCPosition = IN.NDCPosition;
half _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Diffuse_1_Float;
half3 _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Specular_2_Vector3;
half3 _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Color_3_Vector3;
SG_AdditionalLightsURP_97b36dcc0c1df064bab3b4b47d231089_float(_DiffuseLambert_7f9e988376a2438ebc87097469e065d3_Diffuse_1_Float, _Multiply_610f130d22274970bc454dfea38393cd_Out_2_Vector3, _Multiply_9545e2014858428792b92c57dd77e45c_Out_2_Vector3, _BranchOnInputConnection_b3c5feecd28b43998390fb43ac1592b1_Out_3_Vector3, true, _Clamp_6b8538ec3747440bbd39832354f4c497_Out_3_Float, _ReflectanceURP_04ca83d0da3b469cb9b8a8c5c2b3451d_Reflectance_1_Vector3, _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd, _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Diffuse_1_Float, _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Specular_2_Vector3, _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Color_3_Vector3);
float3 _Multiply_765841b19beb4cecb786b3295b6aa8e9_Out_2_Vector3;
Unity_Multiply_float3_float3(_Lerp_7894dcaa210343cc83783b010da9c85c_Out_3_Vector3, (_AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Diffuse_1_Float.xxx), _Multiply_765841b19beb4cecb786b3295b6aa8e9_Out_2_Vector3);
float3 _Multiply_90e8c848b8014b22847c7d7e2db6bcf9_Out_2_Vector3;
Unity_Multiply_float3_float3(_AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Specular_2_Vector3, (_AmbientURP_46e1712500da4aae848bd5b24a05f29f_DirectAO_2_Float.xxx), _Multiply_90e8c848b8014b22847c7d7e2db6bcf9_Out_2_Vector3);
float3 _Add_77980781d2204e1b8d249e5f7058e9fb_Out_2_Vector3;
Unity_Add_float3(_Multiply_765841b19beb4cecb786b3295b6aa8e9_Out_2_Vector3, _Multiply_90e8c848b8014b22847c7d7e2db6bcf9_Out_2_Vector3, _Add_77980781d2204e1b8d249e5f7058e9fb_Out_2_Vector3);
float3 _Multiply_9df1a4a5bf654e97b945b2eccf2fc855_Out_2_Vector3;
Unity_Multiply_float3_float3(_Add_77980781d2204e1b8d249e5f7058e9fb_Out_2_Vector3, _AdditionalLightsURP_973eb4b71588464d8668847c204dc2fd_Color_3_Vector3, _Multiply_9df1a4a5bf654e97b945b2eccf2fc855_Out_2_Vector3);
float3 _Add_ad0b3eccabf24dceb374546c3c332ad7_Out_2_Vector3;
Unity_Add_float3(_Multiply_9df1a4a5bf654e97b945b2eccf2fc855_Out_2_Vector3, _AmbientURP_46e1712500da4aae848bd5b24a05f29f_Ambient_1_Vector3, _Add_ad0b3eccabf24dceb374546c3c332ad7_Out_2_Vector3);
Bindings_Fog_286ae83400099a24bba6faf005588be7_float _Fog_4b5ff09555f14324848244007e17d043;
_Fog_4b5ff09555f14324848244007e17d043.ObjectSpacePosition = IN.ObjectSpacePosition;
half3 _Fog_4b5ff09555f14324848244007e17d043_Out_1_Vector3;
SG_Fog_286ae83400099a24bba6faf005588be7_float(_Add_ad0b3eccabf24dceb374546c3c332ad7_Out_2_Vector3, _Fog_4b5ff09555f14324848244007e17d043, _Fog_4b5ff09555f14324848244007e17d043_Out_1_Vector3);
Lit_1 = _Fog_4b5ff09555f14324848244007e17d043_Out_1_Vector3;
}

// unity-custom-func-begin
void DebugMaterialSwitch_float(float3 None, float3 Albedo, float3 Specular, float3 Alpha, float3 Smoothness, float3 AmbientOcclusion, float3 Emission, float3 NormalWS, float3 NormalTS, float3 LightComplexity, float3 Metallic, float3 SpriteMask, float3 RenderingLayerMasks, out float3 Out){
Out = None;
#if !defined(SHADERGRAPH_PREVIEW) && defined(DEBUG_DISPLAY)
[branch] switch(int(_DebugMaterialMode))

{

    case 0:

        Out = None; break;

    case 1:

        Out = Albedo; break;

    case 2:

        Out = Specular; break;
    case 3:

        Out = Alpha; break;
    case 4:

        Out = Smoothness; break;
    case 5:

        Out = AmbientOcclusion;  break;
    case 6:

        Out = Emission;  break;
    case 7:

        Out = NormalWS * 0.5 + 0.5;  break;
    case 8:

        Out = NormalTS * 0.5 + 0.5;  break;
    case 9:

        Out = LightComplexity;  break;
    case 10:

        Out = Metallic;  break;
    case 11:

        Out = SpriteMask;  break;
    case 12:

        Out = RenderingLayerMasks;  break;

    default:

        Out = None; break;

}
#endif

// Disable this define to prevent the global unlit
// fragment pass to override the color output again.
#undef DEBUG_DISPLAY
}
// unity-custom-func-end

struct Bindings_DebugMaterials_53d20e1f36b55014f99f9ccae649c798_float
{
float3 WorldSpaceNormal;
float3 WorldSpaceTangent;
float3 WorldSpaceBiTangent;
float3 WorldSpacePosition;
float2 NDCPosition;
};

void SG_DebugMaterials_53d20e1f36b55014f99f9ccae649c798_float(float3 _In, float3 _Base_Color, float3 _Normal, float _Metallic, float _Smoothness, float3 _Emission, float _Ambient_Occlusion, float _Alpha, Bindings_DebugMaterials_53d20e1f36b55014f99f9ccae649c798_float IN, out float3 Out_1)
{
float3 _Property_dd011cc96ae64d1181317986b1fa1742_Out_0_Vector3 = _In;
float3 _Property_5653941ce5a641f18f7ce7012652025d_Out_0_Vector3 = _Base_Color;
float _Property_45f5c13ff5544581bd61c2442cecd0a1_Out_0_Float = _Alpha;
float _Property_b6c8b448c5324bd3bc59540f628e43a3_Out_0_Float = _Smoothness;
Bindings_ScreenSpaceAmbientOcclusion_616a08cdf385c2d4997a5ed9d01e16a8_float _ScreenSpaceAmbientOcclusion_40f694c4c3ca4e89acb75242921983f5;
_ScreenSpaceAmbientOcclusion_40f694c4c3ca4e89acb75242921983f5.NDCPosition = IN.NDCPosition;
half _ScreenSpaceAmbientOcclusion_40f694c4c3ca4e89acb75242921983f5_indirectAO_1_Float;
half _ScreenSpaceAmbientOcclusion_40f694c4c3ca4e89acb75242921983f5_directAO_2_Float;
SG_ScreenSpaceAmbientOcclusion_616a08cdf385c2d4997a5ed9d01e16a8_float(_ScreenSpaceAmbientOcclusion_40f694c4c3ca4e89acb75242921983f5, _ScreenSpaceAmbientOcclusion_40f694c4c3ca4e89acb75242921983f5_indirectAO_1_Float, _ScreenSpaceAmbientOcclusion_40f694c4c3ca4e89acb75242921983f5_directAO_2_Float);
float _Property_441143660ff642349088dd1bcab6bc78_Out_0_Float = _Ambient_Occlusion;
float _Minimum_8ee95b9bf7ac4776b6ee4edf1214b3c1_Out_2_Float;
Unity_Minimum_float(_ScreenSpaceAmbientOcclusion_40f694c4c3ca4e89acb75242921983f5_indirectAO_1_Float, _Property_441143660ff642349088dd1bcab6bc78_Out_0_Float, _Minimum_8ee95b9bf7ac4776b6ee4edf1214b3c1_Out_2_Float);
float3 _Property_b171431b5a3b4b0a9fc9fdede4a532a7_Out_0_Vector3 = _Emission;
float3 _Property_db9eb36ed51d4aad95e383920b55e3d7_Out_0_Vector3 = _Normal;
float3 _Transform_9e831bda1f4d4495b24f1f6e3075f2fb_Out_1_Vector3;
{
float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
_Transform_9e831bda1f4d4495b24f1f6e3075f2fb_Out_1_Vector3 = TransformTangentToWorld(_Property_db9eb36ed51d4aad95e383920b55e3d7_Out_0_Vector3.xyz, tangentTransform, true);
}
float3 _Property_4eaab22b2b784aeda3752622f7abaf85_Out_0_Vector3 = _Normal;
float4 _ScreenPosition_121436dfdd464829910775b2326b046b_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
float3 _Property_1b1e0a48277e4883afeb1289a075c5d8_Out_0_Vector3 = _Base_Color;
float3 _LightingComplexityCustomFunction_cbe0c0f96f9046a584e17ead8c001a55_Out_3_Vector3;
LightingComplexity_float((_ScreenPosition_121436dfdd464829910775b2326b046b_Out_0_Vector4.xy), IN.WorldSpacePosition, _Property_1b1e0a48277e4883afeb1289a075c5d8_Out_0_Vector3, _LightingComplexityCustomFunction_cbe0c0f96f9046a584e17ead8c001a55_Out_3_Vector3);
float _Property_dcd3ca7796af45c6857884fa7979898b_Out_0_Float = _Metallic;
float3 _DebugMaterialSwitchCustomFunction_e1fabc2a3bcd4bc183f0e93c379657d4_Out_5_Vector3;
DebugMaterialSwitch_float(_Property_dd011cc96ae64d1181317986b1fa1742_Out_0_Vector3, _Property_5653941ce5a641f18f7ce7012652025d_Out_0_Vector3, float3 (0, 0, 0), (_Property_45f5c13ff5544581bd61c2442cecd0a1_Out_0_Float.xxx), (_Property_b6c8b448c5324bd3bc59540f628e43a3_Out_0_Float.xxx), (_Minimum_8ee95b9bf7ac4776b6ee4edf1214b3c1_Out_2_Float.xxx), _Property_b171431b5a3b4b0a9fc9fdede4a532a7_Out_0_Vector3, _Transform_9e831bda1f4d4495b24f1f6e3075f2fb_Out_1_Vector3, _Property_4eaab22b2b784aeda3752622f7abaf85_Out_0_Vector3, _LightingComplexityCustomFunction_cbe0c0f96f9046a584e17ead8c001a55_Out_3_Vector3, (_Property_dcd3ca7796af45c6857884fa7979898b_Out_0_Float.xxx), float3 (0, 0, 0), float3 (0, 0, 0), _DebugMaterialSwitchCustomFunction_e1fabc2a3bcd4bc183f0e93c379657d4_Out_5_Vector3);
Out_1 = _DebugMaterialSwitchCustomFunction_e1fabc2a3bcd4bc183f0e93c379657d4_Out_5_Vector3;
}

struct Bindings_LitURP_fd8fe8e9e251a39419530ac6ee5a5b61_float
{
float3 WorldSpaceNormal;
float3 WorldSpaceTangent;
float3 WorldSpaceBiTangent;
float3 WorldSpaceViewDirection;
float3 ObjectSpacePosition;
float3 WorldSpacePosition;
float3 AbsoluteWorldSpacePosition;
float2 NDCPosition;
float2 PixelPosition;
half4 uv1;
half4 uv2;
};

void SG_LitURP_fd8fe8e9e251a39419530ac6ee5a5b61_float(float3 _Base_Color, float3 _Normal, float _Metallic, float _Smoothness, float3 _Emission, float _AmbientOcclusion, float _Alpha, Bindings_LitURP_fd8fe8e9e251a39419530ac6ee5a5b61_float IN, out float3 Lit_1)
{
float3 _Property_04a055764411443d802bfbbd0d510c65_Out_0_Vector3 = _Base_Color;
float3 _Property_383a017d83a8420dac016260bc833f58_Out_0_Vector3 = _Normal;
float3 _Transform_3f94cf9dbe844abc9b6727d5d289074f_Out_1_Vector3;
{
float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
_Transform_3f94cf9dbe844abc9b6727d5d289074f_Out_1_Vector3 = TransformTangentToWorld(_Property_383a017d83a8420dac016260bc833f58_Out_0_Vector3.xyz, tangentTransform, true);
}
float _Property_11295d868ff34c388c9212b90b781aff_Out_0_Float = _Metallic;
float _Property_b522b61b85ff4ecbb0eb63cff689f5cb_Out_0_Float = _Smoothness;
float _Property_a1dc37a47c5640d0870861199df0bd70_Out_0_Float = _AmbientOcclusion;
Bindings_ApplyDecals_66e8fc89f7971da4c8964580a0eb9f80_float _ApplyDecals_0413903f5da5491d911d117142eabddd;
_ApplyDecals_0413903f5da5491d911d117142eabddd.PixelPosition = IN.PixelPosition;
half3 _ApplyDecals_0413903f5da5491d911d117142eabddd_BaseColor_1_Vector3;
half3 _ApplyDecals_0413903f5da5491d911d117142eabddd_SpecularColor_2_Vector3;
half3 _ApplyDecals_0413903f5da5491d911d117142eabddd_NormalWS_3_Vector3;
half _ApplyDecals_0413903f5da5491d911d117142eabddd_Metallic_4_Float;
half _ApplyDecals_0413903f5da5491d911d117142eabddd_Smoothness_6_Float;
half _ApplyDecals_0413903f5da5491d911d117142eabddd_AmbientOcclusion_5_Float;
SG_ApplyDecals_66e8fc89f7971da4c8964580a0eb9f80_float(_Property_04a055764411443d802bfbbd0d510c65_Out_0_Vector3, _Transform_3f94cf9dbe844abc9b6727d5d289074f_Out_1_Vector3, _Property_11295d868ff34c388c9212b90b781aff_Out_0_Float, _Property_b522b61b85ff4ecbb0eb63cff689f5cb_Out_0_Float, _Property_a1dc37a47c5640d0870861199df0bd70_Out_0_Float, _ApplyDecals_0413903f5da5491d911d117142eabddd, _ApplyDecals_0413903f5da5491d911d117142eabddd_BaseColor_1_Vector3, _ApplyDecals_0413903f5da5491d911d117142eabddd_SpecularColor_2_Vector3, _ApplyDecals_0413903f5da5491d911d117142eabddd_NormalWS_3_Vector3, _ApplyDecals_0413903f5da5491d911d117142eabddd_Metallic_4_Float, _ApplyDecals_0413903f5da5491d911d117142eabddd_Smoothness_6_Float, _ApplyDecals_0413903f5da5491d911d117142eabddd_AmbientOcclusion_5_Float);
float3 _Property_b986326ad9b34d6ea3a7237ba2bd1cd6_Out_0_Vector3 = _Emission;
Bindings_DebugLighting_61e571d2b9ede1240a524a849d20c997_float _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9;
_DebugLighting_7c013feaa8eb4525bc13d6e4722049d9.WorldSpaceNormal = IN.WorldSpaceNormal;
_DebugLighting_7c013feaa8eb4525bc13d6e4722049d9.WorldSpaceTangent = IN.WorldSpaceTangent;
_DebugLighting_7c013feaa8eb4525bc13d6e4722049d9.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
_DebugLighting_7c013feaa8eb4525bc13d6e4722049d9.WorldSpacePosition = IN.WorldSpacePosition;
_DebugLighting_7c013feaa8eb4525bc13d6e4722049d9.PixelPosition = IN.PixelPosition;
_DebugLighting_7c013feaa8eb4525bc13d6e4722049d9.uv1 = IN.uv1;
_DebugLighting_7c013feaa8eb4525bc13d6e4722049d9.uv2 = IN.uv2;
float3 _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_BaseColor_1_Vector3;
float3 _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Normal_4_Vector3;
float _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Metallic_2_Float;
float _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Smoothness_3_Float;
float3 _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Emission_5_Vector3;
float _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_AmbientOcclusion_6_Float;
SG_DebugLighting_61e571d2b9ede1240a524a849d20c997_float(_ApplyDecals_0413903f5da5491d911d117142eabddd_BaseColor_1_Vector3, _ApplyDecals_0413903f5da5491d911d117142eabddd_NormalWS_3_Vector3, _ApplyDecals_0413903f5da5491d911d117142eabddd_Metallic_4_Float, _ApplyDecals_0413903f5da5491d911d117142eabddd_Smoothness_6_Float, _Property_b986326ad9b34d6ea3a7237ba2bd1cd6_Out_0_Vector3, _ApplyDecals_0413903f5da5491d911d117142eabddd_AmbientOcclusion_5_Float, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_BaseColor_1_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Normal_4_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Metallic_2_Float, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Smoothness_3_Float, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Emission_5_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_AmbientOcclusion_6_Float);
Bindings_LightURP_17836dba1a675e246923104447b19cbd_float _LightURP_4a271a100e74437fb7dc277976b6febf;
_LightURP_4a271a100e74437fb7dc277976b6febf.WorldSpaceNormal = IN.WorldSpaceNormal;
_LightURP_4a271a100e74437fb7dc277976b6febf.WorldSpaceTangent = IN.WorldSpaceTangent;
_LightURP_4a271a100e74437fb7dc277976b6febf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
_LightURP_4a271a100e74437fb7dc277976b6febf.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
_LightURP_4a271a100e74437fb7dc277976b6febf.ObjectSpacePosition = IN.ObjectSpacePosition;
_LightURP_4a271a100e74437fb7dc277976b6febf.WorldSpacePosition = IN.WorldSpacePosition;
_LightURP_4a271a100e74437fb7dc277976b6febf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
_LightURP_4a271a100e74437fb7dc277976b6febf.NDCPosition = IN.NDCPosition;
_LightURP_4a271a100e74437fb7dc277976b6febf.PixelPosition = IN.PixelPosition;
_LightURP_4a271a100e74437fb7dc277976b6febf.uv1 = IN.uv1;
_LightURP_4a271a100e74437fb7dc277976b6febf.uv2 = IN.uv2;
half3 _LightURP_4a271a100e74437fb7dc277976b6febf_Lit_1_Vector3;
SG_LightURP_17836dba1a675e246923104447b19cbd_float(_DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_BaseColor_1_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Normal_4_Vector3, true, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Metallic_2_Float, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Smoothness_3_Float, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_AmbientOcclusion_6_Float, half(1), _LightURP_4a271a100e74437fb7dc277976b6febf, _LightURP_4a271a100e74437fb7dc277976b6febf_Lit_1_Vector3);
float3 _Add_a11e24e7d4fd4494895fd67f375acb21_Out_2_Vector3;
Unity_Add_float3(_LightURP_4a271a100e74437fb7dc277976b6febf_Lit_1_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Emission_5_Vector3, _Add_a11e24e7d4fd4494895fd67f375acb21_Out_2_Vector3);
float _Property_d5e8251fc84a46aea1765511445b653e_Out_0_Float = _Alpha;
Bindings_DebugMaterials_53d20e1f36b55014f99f9ccae649c798_float _DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3;
_DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3.WorldSpaceNormal = IN.WorldSpaceNormal;
_DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3.WorldSpaceTangent = IN.WorldSpaceTangent;
_DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
_DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3.WorldSpacePosition = IN.WorldSpacePosition;
_DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3.NDCPosition = IN.NDCPosition;
float3 _DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3_Out_1_Vector3;
SG_DebugMaterials_53d20e1f36b55014f99f9ccae649c798_float(_Add_a11e24e7d4fd4494895fd67f375acb21_Out_2_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_BaseColor_1_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Normal_4_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Metallic_2_Float, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Smoothness_3_Float, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_Emission_5_Vector3, _DebugLighting_7c013feaa8eb4525bc13d6e4722049d9_AmbientOcclusion_6_Float, _Property_d5e8251fc84a46aea1765511445b653e_Out_0_Float, _DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3, _DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3_Out_1_Vector3);
Lit_1 = _DebugMaterials_c34c7000ddbd4d37b5d71bf460b2fca3_Out_1_Vector3;
}

void Unity_ColorspaceConversion_RGB_HSV_float(float3 In, out float3 Out)
{
    float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    float4 P = lerp(float4(In.bg, K.wz), float4(In.gb, K.xy), step(In.b, In.g));
    float4 Q = lerp(float4(P.xyw, In.r), float4(In.r, P.yzx), step(P.x, In.r));
    float D = Q.x - min(Q.w, Q.y);
    float  E = 1e-10;
    float V = (D == 0) ? Q.x : (Q.x + E);
    Out = float3(abs(Q.z + (Q.w - Q.y)/(6.0 * D + E)), D / (Q.x + E), V);
}

void Unity_Floor_float(float In, out float Out)
{
    Out = floor(In);
}

void Unity_Fraction_float(float In, out float Out)
{
    Out = frac(In);
}

void Unity_Power_float(float A, float B, out float Out)
{
    Out = pow(A, B);
}

void Unity_Sign_float(float In, out float Out)
{
    Out = sign(In);
}

struct Bindings_DynamicSCurve_3565967296b1b074e9007137bcb40394_float
{
};

void SG_DynamicSCurve_3565967296b1b074e9007137bcb40394_float(float _Transition_Sharpness, float _Value, Bindings_DynamicSCurve_3565967296b1b074e9007137bcb40394_float IN, out float Output_2)
{
float _Property_dcf147b7545042b199ca74d23fcbd205_Out_0_Float = _Value;
float _Add_eb03fff2d84e49d587a7742a4b9d1911_Out_2_Float;
Unity_Add_float(_Property_dcf147b7545042b199ca74d23fcbd205_Out_0_Float, _Property_dcf147b7545042b199ca74d23fcbd205_Out_0_Float, _Add_eb03fff2d84e49d587a7742a4b9d1911_Out_2_Float);
float _Property_b6803ebab1d14e28a59f3f0620bc01fe_Out_0_Float = _Transition_Sharpness;
float _Clamp_babb9473387444bba43958a0a940ee34_Out_3_Float;
Unity_Clamp_float(_Property_b6803ebab1d14e28a59f3f0620bc01fe_Out_0_Float, float(0), float(0.99), _Clamp_babb9473387444bba43958a0a940ee34_Out_3_Float);
float _OneMinus_d216a1afb61246768fbf941a2d1a8328_Out_1_Float;
Unity_OneMinus_float(_Clamp_babb9473387444bba43958a0a940ee34_Out_3_Float, _OneMinus_d216a1afb61246768fbf941a2d1a8328_Out_1_Float);
float _Divide_34a05d03980341a3971de4b91620a5bf_Out_2_Float;
Unity_Divide_float(float(1), _OneMinus_d216a1afb61246768fbf941a2d1a8328_Out_1_Float, _Divide_34a05d03980341a3971de4b91620a5bf_Out_2_Float);
float _Power_7b42c3f5820c4805814fd7552688ab96_Out_2_Float;
Unity_Power_float(_Add_eb03fff2d84e49d587a7742a4b9d1911_Out_2_Float, _Divide_34a05d03980341a3971de4b91620a5bf_Out_2_Float, _Power_7b42c3f5820c4805814fd7552688ab96_Out_2_Float);
float _Subtract_12c9f1648de341b4a45af3973e5b972c_Out_2_Float;
Unity_Subtract_float(_Property_dcf147b7545042b199ca74d23fcbd205_Out_0_Float, float(0.5), _Subtract_12c9f1648de341b4a45af3973e5b972c_Out_2_Float);
float _Sign_862dd10c92de4dceb317f801dea4f2d9_Out_1_Float;
Unity_Sign_float(_Subtract_12c9f1648de341b4a45af3973e5b972c_Out_2_Float, _Sign_862dd10c92de4dceb317f801dea4f2d9_Out_1_Float);
float _Add_a2d7a5f001944c6496ce3466c7d6c666_Out_2_Float;
Unity_Add_float(_Sign_862dd10c92de4dceb317f801dea4f2d9_Out_1_Float, float(1), _Add_a2d7a5f001944c6496ce3466c7d6c666_Out_2_Float);
float _Subtract_644715ea3c054db6bc12c0813f096086_Out_2_Float;
Unity_Subtract_float(float(2), _Add_a2d7a5f001944c6496ce3466c7d6c666_Out_2_Float, _Subtract_644715ea3c054db6bc12c0813f096086_Out_2_Float);
float _Multiply_d380040a9ebb4cb5b081d93f3444d4bf_Out_2_Float;
Unity_Multiply_float_float(_Power_7b42c3f5820c4805814fd7552688ab96_Out_2_Float, _Subtract_644715ea3c054db6bc12c0813f096086_Out_2_Float, _Multiply_d380040a9ebb4cb5b081d93f3444d4bf_Out_2_Float);
float _Add_42fd94976e7c42e3a174031a3f7ed22f_Out_2_Float;
Unity_Add_float(_Property_dcf147b7545042b199ca74d23fcbd205_Out_0_Float, _Property_dcf147b7545042b199ca74d23fcbd205_Out_0_Float, _Add_42fd94976e7c42e3a174031a3f7ed22f_Out_2_Float);
float _Subtract_9ff8c56779f1472c846929dd11ae8e10_Out_2_Float;
Unity_Subtract_float(float(2), _Add_42fd94976e7c42e3a174031a3f7ed22f_Out_2_Float, _Subtract_9ff8c56779f1472c846929dd11ae8e10_Out_2_Float);
float _Power_db9493c407d3483a8dc3176196107278_Out_2_Float;
Unity_Power_float(_Subtract_9ff8c56779f1472c846929dd11ae8e10_Out_2_Float, _Divide_34a05d03980341a3971de4b91620a5bf_Out_2_Float, _Power_db9493c407d3483a8dc3176196107278_Out_2_Float);
float _Subtract_3dc49412d7464d2abf5ef1de774e77ff_Out_2_Float;
Unity_Subtract_float(float(2), _Power_db9493c407d3483a8dc3176196107278_Out_2_Float, _Subtract_3dc49412d7464d2abf5ef1de774e77ff_Out_2_Float);
float _Multiply_0a00edfeb8e549478444268e9aa69c00_Out_2_Float;
Unity_Multiply_float_float(_Subtract_3dc49412d7464d2abf5ef1de774e77ff_Out_2_Float, _Add_a2d7a5f001944c6496ce3466c7d6c666_Out_2_Float, _Multiply_0a00edfeb8e549478444268e9aa69c00_Out_2_Float);
float _Add_51a37a0e820549b2ace13c24825f6ff3_Out_2_Float;
Unity_Add_float(_Multiply_d380040a9ebb4cb5b081d93f3444d4bf_Out_2_Float, _Multiply_0a00edfeb8e549478444268e9aa69c00_Out_2_Float, _Add_51a37a0e820549b2ace13c24825f6ff3_Out_2_Float);
float _Multiply_3a2c209c0f54499aa9cd11f5bca1ac5e_Out_2_Float;
Unity_Multiply_float_float(_Add_51a37a0e820549b2ace13c24825f6ff3_Out_2_Float, 0.25, _Multiply_3a2c209c0f54499aa9cd11f5bca1ac5e_Out_2_Float);
Output_2 = _Multiply_3a2c209c0f54499aa9cd11f5bca1ac5e_Out_2_Float;
}

void Unity_Log2_float(float In, out float Out)
{
    Out = log2(In);
}

void Unity_ViewVectorWorld_float(out float3 Out, float3 WorldSpacePosition)
{
    Out = _WorldSpaceCameraPos.xyz - GetAbsolutePositionWS(WorldSpacePosition);
    if(!IsPerspectiveProjection())
    {
        Out = GetViewForwardDir() * dot(Out, GetViewForwardDir());
    }
}

void Unity_Arccosine_float(float In, out float Out)
{
    Out = acos(In);
}

void Unity_InverseLerp_float(float A, float B, float T, out float Out)
{
    Out = (T - A)/(B - A);
}

void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
{
    RGBA = float4(R, G, B, A);
    RGB = float3(R, G, B);
    RG = float2(R, G);
}

void Unity_ColorspaceConversion_HSV_RGB_float(float3 In, out float3 Out)
{
    float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    float3 P = abs(frac(In.xxx + K.xyz) * 6.0 - K.www);
    Out = In.z * lerp(K.xxx, saturate(P - K.xxx), In.y);
}

void Unity_Maximum_float3(float3 A, float3 B, out float3 Out)
{
    Out = max(A, B);
}

struct Bindings_CellLightingModel_28d05442c333727418ac448845e1326b_float
{
float3 WorldSpaceNormal;
float3 TangentSpaceNormal;
float3 WorldSpaceTangent;
float3 WorldSpaceBiTangent;
float3 WorldSpaceViewDirection;
float3 ObjectSpacePosition;
float3 WorldSpacePosition;
float3 AbsoluteWorldSpacePosition;
float2 NDCPosition;
float2 PixelPosition;
half4 uv1;
half4 uv2;
};

void SG_CellLightingModel_28d05442c333727418ac448845e1326b_float(float3 _Color, float3 _Normal, bool _Normal_cff37159d27a438f823fbf468c1fb985_IsConnected, float _Metallic, float _Smoothness, float4 _Emission, float _Ambient_Occlusion, float _Transition_Sharpness, float _Posterization, float _Posterization_Sharpness, float _Rim_Light, Bindings_CellLightingModel_28d05442c333727418ac448845e1326b_float IN, out float3 Color_2)
{
float3 _Property_4bd64118369b459398471ea412165b6d_Out_0_Vector3 = _Color;
float3 _Property_45e1be22194d4e5bac9c49dd235276b2_Out_0_Vector3 = _Normal;
bool _Property_45e1be22194d4e5bac9c49dd235276b2_Out_0_Vector3_IsConnected = _Normal_cff37159d27a438f823fbf468c1fb985_IsConnected;
float3 _BranchOnInputConnection_5509e94253aa40279af357154b1bfc82_Out_3_Vector3 = _Property_45e1be22194d4e5bac9c49dd235276b2_Out_0_Vector3_IsConnected ? _Property_45e1be22194d4e5bac9c49dd235276b2_Out_0_Vector3 : IN.TangentSpaceNormal;
float _Property_364c0d0968c04621a0f5089a26f94b35_Out_0_Float = _Metallic;
float _Property_ae8565d0591149cdbe7378e405bcaf4f_Out_0_Float = _Smoothness;
float4 _Property_47156e0140cb41ca8d7230103d68e17f_Out_0_Vector4 = _Emission;
float _Property_aabb3e299af744ee942d6adf77f21f65_Out_0_Float = _Ambient_Occlusion;
Bindings_LitURP_fd8fe8e9e251a39419530ac6ee5a5b61_float _LitURP_79042709b1054141888f9d40874c578b;
_LitURP_79042709b1054141888f9d40874c578b.WorldSpaceNormal = IN.WorldSpaceNormal;
_LitURP_79042709b1054141888f9d40874c578b.WorldSpaceTangent = IN.WorldSpaceTangent;
_LitURP_79042709b1054141888f9d40874c578b.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
_LitURP_79042709b1054141888f9d40874c578b.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
_LitURP_79042709b1054141888f9d40874c578b.ObjectSpacePosition = IN.ObjectSpacePosition;
_LitURP_79042709b1054141888f9d40874c578b.WorldSpacePosition = IN.WorldSpacePosition;
_LitURP_79042709b1054141888f9d40874c578b.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
_LitURP_79042709b1054141888f9d40874c578b.NDCPosition = IN.NDCPosition;
_LitURP_79042709b1054141888f9d40874c578b.PixelPosition = IN.PixelPosition;
_LitURP_79042709b1054141888f9d40874c578b.uv1 = IN.uv1;
_LitURP_79042709b1054141888f9d40874c578b.uv2 = IN.uv2;
half3 _LitURP_79042709b1054141888f9d40874c578b_Lit_1_Vector3;
SG_LitURP_fd8fe8e9e251a39419530ac6ee5a5b61_float(_Property_4bd64118369b459398471ea412165b6d_Out_0_Vector3, _BranchOnInputConnection_5509e94253aa40279af357154b1bfc82_Out_3_Vector3, _Property_364c0d0968c04621a0f5089a26f94b35_Out_0_Float, _Property_ae8565d0591149cdbe7378e405bcaf4f_Out_0_Float, (_Property_47156e0140cb41ca8d7230103d68e17f_Out_0_Vector4.xyz), _Property_aabb3e299af744ee942d6adf77f21f65_Out_0_Float, half(1), _LitURP_79042709b1054141888f9d40874c578b, _LitURP_79042709b1054141888f9d40874c578b_Lit_1_Vector3);
float3 _ColorspaceConversion_6887f2e74d5145928d4dde174bb981cf_Out_1_Vector3;
Unity_ColorspaceConversion_RGB_HSV_float(_LitURP_79042709b1054141888f9d40874c578b_Lit_1_Vector3, _ColorspaceConversion_6887f2e74d5145928d4dde174bb981cf_Out_1_Vector3);
float _Split_2b8b5bbad0b9449cab8a678b7257b571_R_1_Float = _ColorspaceConversion_6887f2e74d5145928d4dde174bb981cf_Out_1_Vector3[0];
float _Split_2b8b5bbad0b9449cab8a678b7257b571_G_2_Float = _ColorspaceConversion_6887f2e74d5145928d4dde174bb981cf_Out_1_Vector3[1];
float _Split_2b8b5bbad0b9449cab8a678b7257b571_B_3_Float = _ColorspaceConversion_6887f2e74d5145928d4dde174bb981cf_Out_1_Vector3[2];
float _Split_2b8b5bbad0b9449cab8a678b7257b571_A_4_Float = 0;
float _Property_07e622f223754e8db9a1c0f144cf4380_Out_0_Float = _Posterization;
float _Multiply_1f3b4aa4180540e6bab2a8a025323a8a_Out_2_Float;
Unity_Multiply_float_float(_Split_2b8b5bbad0b9449cab8a678b7257b571_R_1_Float, _Property_07e622f223754e8db9a1c0f144cf4380_Out_0_Float, _Multiply_1f3b4aa4180540e6bab2a8a025323a8a_Out_2_Float);
float _Floor_c642d1dbc9ee4877b35ab7b2d38aa451_Out_1_Float;
Unity_Floor_float(_Multiply_1f3b4aa4180540e6bab2a8a025323a8a_Out_2_Float, _Floor_c642d1dbc9ee4877b35ab7b2d38aa451_Out_1_Float);
float _Property_2e80548cd7284658a859582545b6f50e_Out_0_Float = _Posterization_Sharpness;
float _Fraction_5a8094c3579a4c5d9cad4520c2b0cd53_Out_1_Float;
Unity_Fraction_float(_Multiply_1f3b4aa4180540e6bab2a8a025323a8a_Out_2_Float, _Fraction_5a8094c3579a4c5d9cad4520c2b0cd53_Out_1_Float);
Bindings_DynamicSCurve_3565967296b1b074e9007137bcb40394_float _DynamicSCurve_e5598a692a07458e80b116ed256a89e8;
half _DynamicSCurve_e5598a692a07458e80b116ed256a89e8_Output_2_Float;
SG_DynamicSCurve_3565967296b1b074e9007137bcb40394_float(_Property_2e80548cd7284658a859582545b6f50e_Out_0_Float, _Fraction_5a8094c3579a4c5d9cad4520c2b0cd53_Out_1_Float, _DynamicSCurve_e5598a692a07458e80b116ed256a89e8, _DynamicSCurve_e5598a692a07458e80b116ed256a89e8_Output_2_Float);
float _Add_a0c65e7457a1437c81294359341c71c8_Out_2_Float;
Unity_Add_float(_Floor_c642d1dbc9ee4877b35ab7b2d38aa451_Out_1_Float, _DynamicSCurve_e5598a692a07458e80b116ed256a89e8_Output_2_Float, _Add_a0c65e7457a1437c81294359341c71c8_Out_2_Float);
float _Property_aab70366cc8c4df6b7a024d6e1337398_Out_0_Float = _Posterization;
float _Divide_0d9855a4588b49d6b8587fe86caf1004_Out_2_Float;
Unity_Divide_float(_Add_a0c65e7457a1437c81294359341c71c8_Out_2_Float, _Property_aab70366cc8c4df6b7a024d6e1337398_Out_0_Float, _Divide_0d9855a4588b49d6b8587fe86caf1004_Out_2_Float);
float _Log_d5b1a70faf044f85b5d12513aff37699_Out_1_Float;
Unity_Log2_float(_Split_2b8b5bbad0b9449cab8a678b7257b571_B_3_Float, _Log_d5b1a70faf044f85b5d12513aff37699_Out_1_Float);
float _Property_42629d56e9b145958e0034bf344ef226_Out_0_Float = _Metallic;
float _Lerp_fd3d6294a8a34ab8bd8d460c6ab37d6c_Out_3_Float;
Unity_Lerp_float(float(1), float(0.3333333), _Property_42629d56e9b145958e0034bf344ef226_Out_0_Float, _Lerp_fd3d6294a8a34ab8bd8d460c6ab37d6c_Out_3_Float);
float _Multiply_f477590b4b5441cf8614bdd0102f5f32_Out_2_Float;
Unity_Multiply_float_float(_Log_d5b1a70faf044f85b5d12513aff37699_Out_1_Float, _Lerp_fd3d6294a8a34ab8bd8d460c6ab37d6c_Out_3_Float, _Multiply_f477590b4b5441cf8614bdd0102f5f32_Out_2_Float);
float _Floor_f42b74c8270a411da0982fd33f20d5e7_Out_1_Float;
Unity_Floor_float(_Multiply_f477590b4b5441cf8614bdd0102f5f32_Out_2_Float, _Floor_f42b74c8270a411da0982fd33f20d5e7_Out_1_Float);
float _Property_b0041d34b8db46bc8dc49539a104dcf1_Out_0_Float = _Transition_Sharpness;
float _Fraction_3ffc6c982b744f51a6871adf86bb6d17_Out_1_Float;
Unity_Fraction_float(_Multiply_f477590b4b5441cf8614bdd0102f5f32_Out_2_Float, _Fraction_3ffc6c982b744f51a6871adf86bb6d17_Out_1_Float);
Bindings_DynamicSCurve_3565967296b1b074e9007137bcb40394_float _DynamicSCurve_3b9f380ef60e4f3a9cc2812aa84ad9f8;
half _DynamicSCurve_3b9f380ef60e4f3a9cc2812aa84ad9f8_Output_2_Float;
SG_DynamicSCurve_3565967296b1b074e9007137bcb40394_float(_Property_b0041d34b8db46bc8dc49539a104dcf1_Out_0_Float, _Fraction_3ffc6c982b744f51a6871adf86bb6d17_Out_1_Float, _DynamicSCurve_3b9f380ef60e4f3a9cc2812aa84ad9f8, _DynamicSCurve_3b9f380ef60e4f3a9cc2812aa84ad9f8_Output_2_Float);
float _Add_5813508d730241179c839276c1892e54_Out_2_Float;
Unity_Add_float(_Floor_f42b74c8270a411da0982fd33f20d5e7_Out_1_Float, _DynamicSCurve_3b9f380ef60e4f3a9cc2812aa84ad9f8_Output_2_Float, _Add_5813508d730241179c839276c1892e54_Out_2_Float);
float _Divide_22314074bf4949c9b861fbcf57045ed9_Out_2_Float;
Unity_Divide_float(_Add_5813508d730241179c839276c1892e54_Out_2_Float, _Lerp_fd3d6294a8a34ab8bd8d460c6ab37d6c_Out_3_Float, _Divide_22314074bf4949c9b861fbcf57045ed9_Out_2_Float);
float _Property_35eb0e2aa90e42ed906d65f1a3bb0d05_Out_0_Float = _Rim_Light;
float3 _ViewVector_adb78a97b2ea44e088f4b7ce40d0e788_Out_0_Vector3;
Unity_ViewVectorWorld_float(_ViewVector_adb78a97b2ea44e088f4b7ce40d0e788_Out_0_Vector3, IN.WorldSpacePosition);
float _DotProduct_01bbb70d17b94183867e005c1726c4ca_Out_2_Float;
Unity_DotProduct_float3(IN.WorldSpaceNormal, _ViewVector_adb78a97b2ea44e088f4b7ce40d0e788_Out_0_Vector3, _DotProduct_01bbb70d17b94183867e005c1726c4ca_Out_2_Float);
float _Arccosine_64537fb734b44dbba3944b8b84b14c77_Out_1_Float;
Unity_Arccosine_float(_DotProduct_01bbb70d17b94183867e005c1726c4ca_Out_2_Float, _Arccosine_64537fb734b44dbba3944b8b84b14c77_Out_1_Float);
float Constant_f8b656ca1af54d90a3ac98731962d541 = 3.141593;
float _Divide_5804454b417d4000b5e575a6c99f4a86_Out_2_Float;
Unity_Divide_float(Constant_f8b656ca1af54d90a3ac98731962d541, float(2), _Divide_5804454b417d4000b5e575a6c99f4a86_Out_2_Float);
float _Divide_e24683ad45714b83bd59841141f1d367_Out_2_Float;
Unity_Divide_float(_Arccosine_64537fb734b44dbba3944b8b84b14c77_Out_1_Float, _Divide_5804454b417d4000b5e575a6c99f4a86_Out_2_Float, _Divide_e24683ad45714b83bd59841141f1d367_Out_2_Float);
float _InverseLerp_800216468ccc4f728e537a04d670b537_Out_3_Float;
Unity_InverseLerp_float(float(0.5), float(0.8), _Divide_e24683ad45714b83bd59841141f1d367_Out_2_Float, _InverseLerp_800216468ccc4f728e537a04d670b537_Out_3_Float);
float _Saturate_79af768e433046d485dd3e7a63f8b39f_Out_1_Float;
Unity_Saturate_float(_InverseLerp_800216468ccc4f728e537a04d670b537_Out_3_Float, _Saturate_79af768e433046d485dd3e7a63f8b39f_Out_1_Float);
float _Multiply_5dbcd77077d141b6895081ed31cddabf_Out_2_Float;
Unity_Multiply_float_float(_Saturate_79af768e433046d485dd3e7a63f8b39f_Out_1_Float, _Saturate_79af768e433046d485dd3e7a63f8b39f_Out_1_Float, _Multiply_5dbcd77077d141b6895081ed31cddabf_Out_2_Float);
float _Split_6d2339d4cb2945c39e9d2d432789b362_R_1_Float = IN.WorldSpaceNormal[0];
float _Split_6d2339d4cb2945c39e9d2d432789b362_G_2_Float = IN.WorldSpaceNormal[1];
float _Split_6d2339d4cb2945c39e9d2d432789b362_B_3_Float = IN.WorldSpaceNormal[2];
float _Split_6d2339d4cb2945c39e9d2d432789b362_A_4_Float = 0;
float _Float_338deda8c30745b5b2a341ffd1b849ef_Out_0_Float = float(2);
float _Multiply_55f5cbcf511146ea8e37e203068e1f2d_Out_2_Float;
Unity_Multiply_float_float(_Split_6d2339d4cb2945c39e9d2d432789b362_G_2_Float, _Float_338deda8c30745b5b2a341ffd1b849ef_Out_0_Float, _Multiply_55f5cbcf511146ea8e37e203068e1f2d_Out_2_Float);
float _Multiply_fea5f8bf00554b0492150da5dea4ff8e_Out_2_Float;
Unity_Multiply_float_float(_Multiply_5dbcd77077d141b6895081ed31cddabf_Out_2_Float, _Multiply_55f5cbcf511146ea8e37e203068e1f2d_Out_2_Float, _Multiply_fea5f8bf00554b0492150da5dea4ff8e_Out_2_Float);
float _Multiply_1fa0fabbd31f4fcc9f2340408b78185e_Out_2_Float;
Unity_Multiply_float_float(_Property_35eb0e2aa90e42ed906d65f1a3bb0d05_Out_0_Float, _Multiply_fea5f8bf00554b0492150da5dea4ff8e_Out_2_Float, _Multiply_1fa0fabbd31f4fcc9f2340408b78185e_Out_2_Float);
float _Add_a58144872ba94e699c6365f9a593891c_Out_2_Float;
Unity_Add_float(_Divide_22314074bf4949c9b861fbcf57045ed9_Out_2_Float, _Multiply_1fa0fabbd31f4fcc9f2340408b78185e_Out_2_Float, _Add_a58144872ba94e699c6365f9a593891c_Out_2_Float);
float _Power_a5916317387c4081aa32d2933570d809_Out_2_Float;
Unity_Power_float(float(2), _Add_a58144872ba94e699c6365f9a593891c_Out_2_Float, _Power_a5916317387c4081aa32d2933570d809_Out_2_Float);
float _Maximum_b7439812414a4be3817cda571c4ec1e2_Out_2_Float;
Unity_Maximum_float(_Power_a5916317387c4081aa32d2933570d809_Out_2_Float, float(0), _Maximum_b7439812414a4be3817cda571c4ec1e2_Out_2_Float);
float4 _Combine_ebb6335325ea4a278687c3cd845f0e6e_RGBA_4_Vector4;
float3 _Combine_ebb6335325ea4a278687c3cd845f0e6e_RGB_5_Vector3;
float2 _Combine_ebb6335325ea4a278687c3cd845f0e6e_RG_6_Vector2;
Unity_Combine_float(_Divide_0d9855a4588b49d6b8587fe86caf1004_Out_2_Float, _Split_2b8b5bbad0b9449cab8a678b7257b571_G_2_Float, _Maximum_b7439812414a4be3817cda571c4ec1e2_Out_2_Float, _Split_2b8b5bbad0b9449cab8a678b7257b571_A_4_Float, _Combine_ebb6335325ea4a278687c3cd845f0e6e_RGBA_4_Vector4, _Combine_ebb6335325ea4a278687c3cd845f0e6e_RGB_5_Vector3, _Combine_ebb6335325ea4a278687c3cd845f0e6e_RG_6_Vector2);
float3 _ColorspaceConversion_3250b73e99a641879c8e577d36c10ad3_Out_1_Vector3;
Unity_ColorspaceConversion_HSV_RGB_float(_Combine_ebb6335325ea4a278687c3cd845f0e6e_RGB_5_Vector3, _ColorspaceConversion_3250b73e99a641879c8e577d36c10ad3_Out_1_Vector3);
float3 _Maximum_1e2393ebc3604d58b11e0e38db091040_Out_2_Vector3;
Unity_Maximum_float3(_ColorspaceConversion_3250b73e99a641879c8e577d36c10ad3_Out_1_Vector3, float3(0, 0, 0), _Maximum_1e2393ebc3604d58b11e0e38db091040_Out_2_Vector3);
Color_2 = _Maximum_1e2393ebc3604d58b11e0e38db091040_Out_2_Vector3;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
description.Position = IN.ObjectSpacePosition;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
float3 BaseColor;
float Alpha;
float AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
float4 _Property_55c5ce2527444284851f451829601335_Out_0_Vector4 = _Color;
UnityTexture2D _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D = UnityBuildTexture2DStructInternal(_Base, sampler_Base, _Base_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.tex, _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.samplerstate, _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
if (_Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4, _Property_45e89bad8f5447d6be4b3c5861a40546_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_R_4_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.r;
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_G_5_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.g;
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_B_6_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.b;
float _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_A_7_Float = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4.a;
float4 _Multiply_61f37827eac943e8ae93f89ea0e75526_Out_2_Vector4;
Unity_Multiply_float4_float4(_Property_55c5ce2527444284851f451829601335_Out_0_Vector4, _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_RGBA_0_Vector4, _Multiply_61f37827eac943e8ae93f89ea0e75526_Out_2_Vector4);
UnityTexture2D _Property_fc20f84db7324d36bceb15e6e11ceecd_Out_0_Texture2D = UnityBuildTexture2DStructInternal(_Normal, sampler_Normal, _Normal_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_fc20f84db7324d36bceb15e6e11ceecd_Out_0_Texture2D.tex, _Property_fc20f84db7324d36bceb15e6e11ceecd_Out_0_Texture2D.samplerstate, _Property_fc20f84db7324d36bceb15e6e11ceecd_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
if (_Property_fc20f84db7324d36bceb15e6e11ceecd_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4, _Property_fc20f84db7324d36bceb15e6e11ceecd_Out_0_Texture2D.hdrDecode);
_SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4);
float _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_R_4_Float = _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4.r;
float _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_G_5_Float = _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4.g;
float _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_B_6_Float = _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4.b;
float _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_A_7_Float = _SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4.a;
UnityTexture2D _Property_92e95d909f834786a128db3d4630a44b_Out_0_Texture2D = UnityBuildTexture2DStructInternal(_Metallic_Smoothness, sampler_Metallic_Smoothness, _Metallic_Smoothness_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_92e95d909f834786a128db3d4630a44b_Out_0_Texture2D.tex, _Property_92e95d909f834786a128db3d4630a44b_Out_0_Texture2D.samplerstate, _Property_92e95d909f834786a128db3d4630a44b_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
if (_Property_92e95d909f834786a128db3d4630a44b_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_RGBA_0_Vector4, _Property_92e95d909f834786a128db3d4630a44b_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_R_4_Float = _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_RGBA_0_Vector4.r;
float _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_G_5_Float = _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_RGBA_0_Vector4.g;
float _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_B_6_Float = _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_RGBA_0_Vector4.b;
float _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_A_7_Float = _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_RGBA_0_Vector4.a;
UnityTexture2D _Property_67a0baf82c6944c794901261ce853689_Out_0_Texture2D = UnityBuildTexture2DStructInternal(_Emissive, sampler_Emissive, _Emissive_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_67a0baf82c6944c794901261ce853689_Out_0_Texture2D.tex, _Property_67a0baf82c6944c794901261ce853689_Out_0_Texture2D.samplerstate, _Property_67a0baf82c6944c794901261ce853689_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
if (_Property_67a0baf82c6944c794901261ce853689_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_RGBA_0_Vector4, _Property_67a0baf82c6944c794901261ce853689_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_R_4_Float = _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_RGBA_0_Vector4.r;
float _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_G_5_Float = _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_RGBA_0_Vector4.g;
float _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_B_6_Float = _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_RGBA_0_Vector4.b;
float _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_A_7_Float = _SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_RGBA_0_Vector4.a;
float _Property_737a7264eace4aea95a66c4d180a7185_Out_0_Float = _Emissive_Intensity;
float4 _Multiply_1aa7109ad0954efcb2fe516c58411c07_Out_2_Vector4;
Unity_Multiply_float4_float4(_SampleTexture2D_beeb5b6e5bb14c7da581559806ac49b1_RGBA_0_Vector4, (_Property_737a7264eace4aea95a66c4d180a7185_Out_0_Float.xxxx), _Multiply_1aa7109ad0954efcb2fe516c58411c07_Out_2_Vector4);
float _Property_723bcef9d5144a12a1dca50553bdb967_Out_0_Float = _Transition_Sharpness;
float _Property_fbfc24be29d34dac98d3e99017691876_Out_0_Float = _Posterization;
float _Property_046028dd74834f0aaeb44803d6ad4c72_Out_0_Float = _Posterization_Sharpness;
float _Property_6cbdfa1aaa89402a8ef11aa9addda98f_Out_0_Float = _Rim_Light;
Bindings_CellLightingModel_28d05442c333727418ac448845e1326b_float _CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.WorldSpaceNormal = IN.WorldSpaceNormal;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.TangentSpaceNormal = IN.TangentSpaceNormal;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.WorldSpaceTangent = IN.WorldSpaceTangent;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.ObjectSpacePosition = IN.ObjectSpacePosition;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.WorldSpacePosition = IN.WorldSpacePosition;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.NDCPosition = IN.NDCPosition;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.PixelPosition = IN.PixelPosition;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.uv1 = IN.uv1;
_CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2.uv2 = IN.uv2;
float3 _CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2_Color_2_Vector3;
SG_CellLightingModel_28d05442c333727418ac448845e1326b_float((_Multiply_61f37827eac943e8ae93f89ea0e75526_Out_2_Vector4.xyz), (_SampleTexture2D_eebaaac4fc7646cd9dd1dc98f73fce90_RGBA_0_Vector4.xyz), true, _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_R_4_Float, _SampleTexture2D_39011eb6ea1b455e8843a5d0dd69b733_A_7_Float, _Multiply_1aa7109ad0954efcb2fe516c58411c07_Out_2_Vector4, float(1), _Property_723bcef9d5144a12a1dca50553bdb967_Out_0_Float, _Property_fbfc24be29d34dac98d3e99017691876_Out_0_Float, _Property_046028dd74834f0aaeb44803d6ad4c72_Out_0_Float, _Property_6cbdfa1aaa89402a8ef11aa9addda98f_Out_0_Float, _CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2, _CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2_Color_2_Vector3);
surface.BaseColor = _CellLightingModel_684ca3aa931641dd8fe7ae7f209f79d2_Color_2_Vector3;
surface.Alpha = _SampleTexture2D_15b841c98d0e4154a8e7bbaf00d21e3a_A_7_Float;
surface.AlphaClipThreshold = float(0.5);
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
#if VFX_USE_GRAPH_VALUES
    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
#endif
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    

    // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
    float3 unnormalizedNormalWS = input.normalWS;
    const float renormFactor = 1.0 / length(unnormalizedNormalWS);

    // use bitangent on the fly like in hdrp
    // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
    float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
    float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);

    output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);

    // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
    // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
    output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
    output.WorldSpaceBiTangent = renormFactor * bitang;

    output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
    output.WorldSpacePosition = input.positionWS;
    output.ObjectSpacePosition = TransformWorldToObject(input.positionWS);
    output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);

    #if UNITY_UV_STARTS_AT_TOP
    output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
    #else
    output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
    #endif

    output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
    output.NDCPosition.y = 1.0f - output.NDCPosition.y;

    output.uv0 = input.texCoord0;
    output.uv1 = input.texCoord1;
    output.uv2 = input.texCoord2;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
}
CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
CustomEditorForRenderPipeline "UnityEditor.ShaderGraphUnlitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
FallBack "Hidden/Shader Graph/FallbackError"
}