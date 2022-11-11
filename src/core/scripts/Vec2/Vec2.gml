function Vec2(_x, _y) constructor {
    x = _x;
    y = _y;
	
    static translate = function(a) {
        x += a.x;
        y += a.y;
    }
    
    static scale = function(s) {
        x *= s;
        y *= s;
    }
    
    static add = function(a) {
        return new Vec2(x+a.x, y+a.y);
    }
    
    static negate = function() {
        return new Vec2(-x, -y);
    }
    
    static scalar_multiply = function(s) {
        return new Vec2(x * s, y * s);
    }
    
    static component_multiply = function(a) {
        return new Vec2(x * a.x, y * a.y);
    }
    
    static vmax = function(a) {
        return new Vec2(
            max(x, a.x),
            max(y, a.y)
        );
    }
}