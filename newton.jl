using Images
using IntervalSets
using LinearAlgebra
using ForwardDiff

struct Canvas
    Ix :: ClosedInterval{Float64}
    Iy :: ClosedInterval{Float64}
    ppu :: Int
end

function get_xy(canvas::Canvas)
    ax, bx = endpoints(canvas.Ix)
    ay, by = endpoints(canvas.Iy)
    lx = IntervalSets.width(canvas.Ix)
    ly = IntervalSets.width(canvas.Iy)
    nx = Int(round(lx*canvas.ppu))
    ny = Int(round(ly*canvas.ppu))
    startx = ax + lx/2nx
    starty = ay + ly/2ny
    endx = bx - lx/2nx
    endy = by - ly/2ny
    xs = range(startx, endx, length=nx)
    ys = range(endy, starty, length=ny)
    return xs, ys
end

## Example1
f(x,y) = x^2+y^2-4
g(x,y) = x^2-y^2-2
exacts = [[1.7321,1],[-1.7321,1],[1.7321,-1],[-1.7321,-1]]

F(X) = [f(X[1], X[2]), g(X[1], X[2])]
∇F(X) = ForwardDiff.jacobian(F,X)
function newton_iter(X)
    return X - ∇F(X)\F(X)
end
function col(X)
    X
    for i in 1:20
        X = newton_iter(X)
        if norm(X - exacts[1])<0.1
            return RGB(1,0,0)
        elseif norm(X - exacts[2])<0.1
            return RGB(1,1,0)
        elseif norm(X - exacts[3])<0.1
            return RGB(0,0,1)
        elseif norm(X - exacts[4])<0.1
            return RGB(0,1,0)
        end
    end
    return RGB(1,1,1)
end
canvas = Canvas(-10..10, -10..10, 50)
xs, ys = get_xy(canvas)
Xs = [[x,y] for y in ys, x in xs]
img = [col(X) for X in Xs]
save("example1.png", img)


## Example1a
f(x,y) = x^2+y^2-3.9-x/2
g(x,y) = x^2-y^2-2
exacts = [[-1.597,0.742],[-1.597,-0.742],[1.847,1.188],[1.847,-1.188]]

F(X) = [f(X[1], X[2]), g(X[1], X[2])]
∇F(X) = ForwardDiff.jacobian(F,X)
function newton_iter(X)
    return X - ∇F(X)\F(X)
end
function col(X)
    X
    for i in 1:100
        X = newton_iter(X)
        if norm(X - exacts[1])<0.1
            return Images.Colors.JULIA_LOGO_COLORS[1]
        elseif norm(X - exacts[2])<0.1
            return Images.Colors.JULIA_LOGO_COLORS[2]
        elseif norm(X - exacts[3])<0.1
            return Images.Colors.JULIA_LOGO_COLORS[3]
        elseif norm(X - exacts[4])<0.1
            return Images.Colors.JULIA_LOGO_COLORS[4]
        end
    end
    return RGB(1,1,1)
end
canvas = Canvas(-10..10, -10..10, 80)
xs, ys = get_xy(canvas)
Xs = [[x,y] for y in ys, x in xs]
img = [col(X) for X in Xs]
save("example1a.png", img)


## Example2
f(x,y) = x^2/5+y^2/5-y^4/15-0.3
g(x,y) = x^2-2y^2+2
exacts = [[0.869,1.174],[-0.869,1.174],[0.869,-1.174],[-0.869,-1.174],
        [3.639,2.761],[-3.639,2.761],[3.639,-2.761],[-3.639,-2.761]]

F(X) = [f(X[1], X[2]), g(X[1], X[2])]
∇F(X) = ForwardDiff.jacobian(F,X)
function newton_iter(X)
    return X - ∇F(X)\F(X)
end
function col(X)
    X
    for i in 1:100
        X = newton_iter(X)
        if norm(X - exacts[1])<0.1
            return RGB(1,0.8,0.8)
        elseif norm(X - exacts[2])<0.1
            return RGB(1,0.6,0.6)
        elseif norm(X - exacts[3])<0.1
            return RGB(1,0.4,0.4)
        elseif norm(X - exacts[4])<0.1
            return RGB(1,0.2,0.2)
        elseif norm(X - exacts[5])<0.1
            return RGB(0.8,0.8,1)
        elseif norm(X - exacts[6])<0.1
            return RGB(0.6,0.6,1)
        elseif norm(X - exacts[7])<0.1
            return RGB(0.4,0.4,1)
        elseif norm(X - exacts[8])<0.1
            return RGB(0.2,0.2,1)
        end
    end
    return RGB(1,1,1)
end
canvas = Canvas(-10..10, -5..5, 100)
xs, ys = get_xy(canvas)
Xs = [[x,y] for y in ys, x in xs]
img = [col(X) for X in Xs]
save("example2.png", img)
