Shader "Unlit/Animation"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color:COLOR;
                float3 normal:NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float4 color:COLOR;
                float3 normal:NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4 RotateAroundYInDegrees(float4 vertex, float degrees)
            {
                float alpha = degrees * UNITY_PI / 180.0;
                float sina, cosa;
                sincos(alpha, sina, cosa);
                float2x2 m = float2x2(cosa, -sina, sina, cosa);
                return float4(mul(m, vertex.xz), vertex.yw).xzyw;
            }

            v2f vert(appdata v)
            {
                v2f o;                

                float3 vertex = (v.vertex + float3(0, sin(2.5 * _Time.z) * .6, 0));
                float4 rotatedVec = RotateAroundYInDegrees(float4(vertex, v.vertex.w), 75 * _Time.y);
                o.vertex = UnityObjectToClipPos(rotatedVec);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                o.normal = v.normal;
                o.color = v.color;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 wnormal = normalize(mul(float4(i.normal, 0.0),unity_WorldToObject)).xyz;
                float3 lightpos = normalize(_WorldSpaceLightPos0).xyz;
                float finalcolor = dot(wnormal, lightpos);
                fixed4 col = tex2D(_MainTex, i.uv) * finalcolor * 3;

                return col;
            }
            ENDCG
        }
    }
}
