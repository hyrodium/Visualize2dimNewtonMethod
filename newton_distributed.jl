using Distributed
addprocs(13)

@everywhere using Images
@everywhere using IntervalSets
@everywhere using LinearAlgebra
@everywhere using ForwardDiff

@everywhere struct Canvas
    Ix :: ClosedInterval{Float64}
    Iy :: ClosedInterval{Float64}
    ppu :: Int
end

@everywhere function get_xy(canvas::Canvas)
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

## Example3
@everywhere f(x,y) = x^4+y^6-5
@everywhere g(x,y) = cos(x)-sin(y)-0.3
@everywhere exacts = [[1.49533,-0.2265],[-1.49533,-0.2265]]

@everywhere F(X) = [f(X[1], X[2]), g(X[1], X[2])]
@everywhere ∇F(X) = ForwardDiff.jacobian(F,X)
@everywhere function newton_iter(X)
    return X - ∇F(X)\F(X)
end
@everywhere function col(X)
    X
    for i in 1:200
        try
            X = newton_iter(X)
        catch
            return RGB(1,1,1)
        end
        if norm(X - exacts[1])<0.1
            return RGB(0.6,0.6,1)
        elseif norm(X - exacts[2])<0.1
            return RGB(1,0.6,0.6)
        end
    end
    return RGB(1,1,1)
end
@everywhere canvas = Canvas(-10..10, -10..10, 50)
@everywhere xs, ys = get_xy(canvas)
@everywhere Xs = [[x,y] for y in ys, x in xs]
img_future = [(@spawn col(X)) for X in Xs]
img = fetch.(img_future)
save("example3.png", img)
