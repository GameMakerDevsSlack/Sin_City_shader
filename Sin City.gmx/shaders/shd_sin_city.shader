attribute vec3 in_Position;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main() {
    
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
    
}

//######################_==_YOYO_SHADER_MARKER_==_######################@~varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_fCurve;

vec3 rgb2hsv( vec3 _c ) {
    vec4 _K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 _p = mix(vec4(_c.bg, _K.wz), vec4(_c.gb, _K.xy), step(_c.b, _c.g));
    vec4 _q = mix(vec4(_p.xyw, _c.r), vec4(_c.r, _p.yzx), step(_p.x, _c.r));
    
    float _d = _q.x - min(_q.w, _q.y);
    return vec3(abs(_q.z + (_q.w - _q.y) / (6.0 * _d)), _d / _q.x, _q.x);
}

vec3 hsv2rgb( vec3 _c ) {
    vec4 _K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 _p = abs(fract(_c.xxx + _K.xyz) * 6.0 - _K.www);
    return _c.z * mix(_K.xxx, clamp(_p - _K.xxx, 0.0, 1.0), _c.y);
}

void main() {
    vec4 sample = texture2D( gm_BaseTexture, v_vTexcoord );
    vec3 hsv = rgb2hsv( sample.rgb );
    hsv.g *= smoothstep( 0.0, 1.0, max( 0.0, max( 1.0 - u_fCurve*hsv.r, u_fCurve*hsv.r - u_fCurve + 1.0 ) ) );
    gl_FragColor = v_vColour * vec4( hsv2rgb( hsv ), sample.a );
}

