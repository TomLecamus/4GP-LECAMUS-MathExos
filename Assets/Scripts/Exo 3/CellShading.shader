// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/CellShading"
{
	Properties
	{
		_DiffuseLightColor("DiffuseLightColor", Color) = (0,0,0,0)
		_DiffuseDarkColor("DiffuseDarkColor", Color) = (0,0,0,0)
		_DiffuseThreshold("DiffuseThreshold", Range( 0 , 1)) = 0.2535545
		_SpecularColor("SpecularColor", Color) = (0,0,0,0)
		_SpecularWidth("SpecularWidth", Range( 0 , 1)) = 0.5
		_SpecularStrength("SpecularStrength", Float) = 10
		_RimColor("RimColor", Color) = (0,0,0,0)
		_RimWidth("RimWidth", Range( 0 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		ZWrite On
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float3 viewDir;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float4 _DiffuseLightColor;
		uniform float _DiffuseThreshold;
		uniform float4 _DiffuseDarkColor;
		uniform float _SpecularStrength;
		uniform float _SpecularWidth;
		uniform float4 _SpecularColor;
		uniform float _RimWidth;
		uniform float4 _RimColor;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 ase_worldNormal = i.worldNormal;
			float dotResult4 = dot( ase_worldlightDir , ase_worldNormal );
			float temp_output_16_0 = step( _DiffuseThreshold , max( dotResult4 , 0.0 ) );
			float dotResult26 = dot( reflect( -ase_worldlightDir , ase_worldNormal ) , i.viewDir );
			float dotResult47 = dot( ( 1.0 - i.viewDir ) , ase_worldNormal );
			float smoothstepResult56 = smoothstep( 0.45 , 0.55 , pow( max( dotResult47 , 0.0 ) , ( 1.0 - _RimWidth ) ));
			c.rgb = ( ( ( _DiffuseLightColor * temp_output_16_0 ) + ( _DiffuseDarkColor * ( 1.0 - temp_output_16_0 ) ) ) + ( step( ( 1.0 - pow( max( dotResult26 , 0.0 ) , _SpecularStrength ) ) , _SpecularWidth ) * _SpecularColor ) + ( smoothstepResult56 * _RimColor ) ).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 worldPos : TEXCOORD1;
				float3 worldNormal : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18800
306;101;1434;819;-479.545;-686.6269;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;43;-1407.66,705.3246;Inherit;False;2152.503;795.4314;SPECULAR;14;18;25;17;27;24;26;31;38;19;36;39;28;41;30;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;17;-1351.757,922.179;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;15;-1223.947,-184.5097;Inherit;False;1960.19;816.5381;DIFFUSE;13;35;4;3;2;6;1;96;7;14;94;13;11;16;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;54;-739.6497,1629.459;Inherit;False;1487.157;499.7625;RIM LIGHTING;11;47;48;49;46;55;50;57;52;45;56;53;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;18;-1320.299,1063.525;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;25;-1128.426,922.078;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;3;-1133.886,459.6377;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;46;-677.317,1802.834;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;2;-1161.875,309.5552;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ReflectOpNode;24;-980.426,1039.078;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;27;-907.033,1260.149;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;4;-921.3813,362.2151;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;48;-700.4507,1963.118;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;49;-502.2703,1859.491;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;26;-687.4263,1240.078;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;35;-629.6708,362.0716;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;31;-440.9984,1241.081;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-442.9114,1153.103;Inherit;False;Property;_SpecularStrength;SpecularStrength;5;0;Create;True;0;0;0;False;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;47;-342.6736,1894.497;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-440.1171,1717.001;Inherit;False;Property;_RimWidth;RimWidth;7;0;Create;True;0;0;0;False;0;False;0;0.207;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-711.6749,225.8553;Inherit;False;Property;_DiffuseThreshold;DiffuseThreshold;2;0;Create;True;0;0;0;False;0;False;0.2535545;0.264;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;55;-121.9366,1895.207;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;57;-175.3909,1720.972;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;16;-397.2791,363.898;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;30;-161.9983,1241.081;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;52;26.72962,1894.491;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;14;-92.4576,359.803;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;96;-160.1017,172.165;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-124.0751,182.2552;Inherit;False;Property;_DiffuseDarkColor;DiffuseDarkColor;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.08887281,0.3679245,0.03991635,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;38;69.50238,1252.346;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-160.5975,1132.046;Inherit;False;Property;_SpecularWidth;SpecularWidth;4;0;Create;True;0;0;0;False;0;False;0.5;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-124.075,-22.84469;Inherit;False;Property;_DiffuseLightColor;DiffuseLightColor;0;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.3224561,0.8117647,0.2196077,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;56;256.9937,1894.412;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.45;False;2;FLOAT;0.55;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;45;281.3564,1702.494;Inherit;False;Property;_RimColor;RimColor;6;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.2532587,0.2830189,0.1909042,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;187.8146,108.5986;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;190.9192,332.7202;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;19;222.4963,980.8246;Inherit;False;Property;_SpecularColor;SpecularColor;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;36;222.8025,1195.546;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;516.4613,1896.857;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;459.4704,307.5135;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;472.0407,1200.813;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;898.1487,1176.518;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1277.391,919.9176;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Custom/CellShading;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;17;0
WireConnection;24;0;25;0
WireConnection;24;1;18;0
WireConnection;4;0;2;0
WireConnection;4;1;3;0
WireConnection;49;0;46;0
WireConnection;26;0;24;0
WireConnection;26;1;27;0
WireConnection;35;0;4;0
WireConnection;31;0;26;0
WireConnection;47;0;49;0
WireConnection;47;1;48;0
WireConnection;55;0;47;0
WireConnection;57;0;50;0
WireConnection;16;0;6;0
WireConnection;16;1;35;0
WireConnection;30;0;31;0
WireConnection;30;1;28;0
WireConnection;52;0;55;0
WireConnection;52;1;57;0
WireConnection;14;0;16;0
WireConnection;96;0;16;0
WireConnection;38;0;30;0
WireConnection;56;0;52;0
WireConnection;94;0;1;0
WireConnection;94;1;96;0
WireConnection;13;0;7;0
WireConnection;13;1;14;0
WireConnection;36;0;38;0
WireConnection;36;1;39;0
WireConnection;53;0;56;0
WireConnection;53;1;45;0
WireConnection;11;0;94;0
WireConnection;11;1;13;0
WireConnection;41;0;36;0
WireConnection;41;1;19;0
WireConnection;44;0;11;0
WireConnection;44;1;41;0
WireConnection;44;2;53;0
WireConnection;0;13;44;0
ASEEND*/
//CHKSM=50685FBCB592B9B8D5FB82D1FAA7B857C4F2AE9B