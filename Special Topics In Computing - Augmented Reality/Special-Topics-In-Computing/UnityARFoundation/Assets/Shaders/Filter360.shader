// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

// Unlit shader. Simplest possible textured shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Custom/Filter360" {
Properties {
    _MainTex ("Base (RGB)", 2D) = "white" {}
    // [Enum(Equal,3,NotEqual,6)] _StencilTest ("Stencil Test", int) = 6
}

SubShader {
    Cull front
    Tags { "RenderType"="Opaque" }
    LOD 100
            Stencil {
            Ref 1
            Comp [_StencilTest]
        }
        
    Pass {
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata_t {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                float2 texcoord : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                UNITY_VERTEX_OUTPUT_STEREO
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata_t v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = float2(1. - i.texcoord.x, i.texcoord.y);
                fixed4 col = tex2D(_MainTex,  uv);
                UNITY_APPLY_FOG(i.fogCoord, col);
                UNITY_OPAQUE_ALPHA(col.a);
                return col;
            }
        ENDCG
    }
}

}


//Shader "Custom/Filter360" {
//    Properties {
//        _Color ("Main Color", Color) = (1,1,1,1)
//        _MainTex ("Diffuse (RGB) Alpha (A)", 2D) = "gray" {}
//    }

//    SubShader{
//         Stencil {
//            Ref 1
//            Comp [_StencilTest]
//        }
//        Pass {
//            Tags {"LightMode" = "Always"}

//            CGPROGRAM
//                #pragma vertex vert
//                #pragma fragment frag
//                #pragma fragmentoption ARB_precision_hint_fastest
//                #pragma glsl
//                #pragma target 3.0

//                #include "UnityCG.cginc"

//                struct appdata {
//                   float4 vertex : POSITION;
//                   float3 normal : NORMAL;
//                };

//                struct v2f
//                {
//                    float4    pos : SV_POSITION;
//                    float3    normal : TEXCOORD0;
//                };

//                v2f vert (appdata v)
//                {
//                    v2f o;
//                    o.pos = UnityObjectToClipPos(v.vertex);
//                    o.normal = v.normal;
//                    return o;
//                }

//                sampler2D _MainTex;

//                #define PI 3.141592653589793

//                inline float2 RadialCoords(float3 a_coords)
//                {
//                    float3 a_coords_n = normalize(a_coords);
//                    float lon = atan2(a_coords_n.z, a_coords_n.x);
//                    float lat = acos(a_coords_n.y);
//                    float2 sphereCoords = float2(lon, lat) * (1.0 / PI);
//                    return float2(sphereCoords.x * 0.5 + 0.5, 1 - sphereCoords.y);
//                }

//                float4 frag(v2f IN) : COLOR
//                {
//                    float2 equiUV = RadialCoords(IN.normal);
//                    return tex2D(_MainTex, equiUV);
//                }
//            ENDCG
//        }
//    }
    
//}