#ifdef FRAGMENT_SHADER
    /* DRAWBUFFERS:0 */

    void main() {
        gl_FragData[0] = vec4(0.0);
    }
#endif

#ifdef VERTEX_SHADER
    void main() {
        gl_Position = ftransform();
    }
#endif