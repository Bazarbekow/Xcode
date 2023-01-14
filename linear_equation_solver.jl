using Gtk
using JSON
using LinearAlgebra

#= Beispiele von linearen Gleichungen Systems
    Das ist A:
    2x - y - z = 1
    -x + 3y - z = 2
    -x -y + 2z = 3

    A*x = b

    | 2 -1 -1|      | z |   | 1 |
    |-1  3 -1| *    | y | = | 2 |
    |-1 -1  2|      | z |   | 3 |

    1. schritte: Die koeffizienten für das lineare System definieren:
    A = [2.0 -1.0 -1.0; -1.0 3.0 -1.0; -1.0 -1.0 2.0] #koeffizienten
    b = [1.0, 2.0, 3.0] # konstanten
    x = A \ b # / operator wird zum Lösen des Systems benutzt!
    Alternative: x = linsolve(A, b) (funktion ist im LinearAlgebraPacket)

    Andere Methoden:

    LU-Dekomposition (1):
    L, U, p = lu(A)
    x = U \ (L \ b[p])

    QR-Dekomposition (2):
    Q, R = qr(A)
    x= R \ (Q'b)

    Cholesky:
    R = cholesky(A)
    x = R \ (R' \ b)



=#

# Using Gtk library

fen = GtkWindow("Lineare Gleichungen Loeser", 400, 400) #400x400 Fenster



function solve_linsys(A, b)
    try
        b = JSON.parse(b)
        b = convert(Vector{Float64}, b)
        x = A \ b
        #Das Ereignis drucken:
        println("Lösung: ", x)
        return "Loesung: $(x)"
    catch
        return "Eingabe ist fehlerhaft. Bitte geben sie erneut die richtige Matrix und Vektor ein!"
    end 
end

A_entry = GtkEntry()

entry_1 = GtkEntry()
entry_11 = GtkEntry()
entry_111 = GtkEntry()
entry_2 = GtkEntry()
entry_22 = GtkEntry()
entry_222 = GtkEntry()
entry_3 = GtkEntry()
entry_33 = GtkEntry()
entry_333 = GtkEntry()

b_entry = GtkEntry()
result_label = GtkLabel("")
button = GtkButton("Lösen") #Button in Gtk

# set button callback

id = signal_connect(button, "button-press-event") do widget, event
    x1 = get_gtk_property(entry_1, :text, String)
    x1 = parse(Float64, x1)
    x11 = get_gtk_property(entry_11, :text, String)
    x11 = parse(Float64, x11)
    x111 = get_gtk_property(entry_111, :text, String)
    x111 = parse(Float64, x111)
    x2 = get_gtk_property(entry_2, :text, String)
    x2 = parse(Float64, x2)
    x22 = get_gtk_property(entry_22, :text, String)
    x22 = parse(Float64, x22)
    x222 = get_gtk_property(entry_222, :text, String)
    x222 = parse(Float64, x222)
    x3 = get_gtk_property(entry_3, :text, String)
    x3 = parse(Float64, x3)
    x33 = get_gtk_property(entry_33, :text, String)
    x33 = parse(Float64, x33)
    x333 = get_gtk_property(entry_333, :text, String)
    x333 = parse(Float64, x333)
    A = [x1 x11 x111; x2 x22 x222; x3 x33 x333]
    b = get_gtk_property(b_entry, :text, String)

    result = solve_linsys(A, b)
    GAccessor.text(result_label, result) #Ereignis kriegen
end

grid = GtkGrid()
grid[1,1] = GtkLabel("Matrix A")
grid[2,1] = entry_1
grid[3,1] = entry_11
grid[4,1] = entry_111

grid[2,2] = entry_2
grid[3,2] = entry_22
grid[4,2] = entry_222

grid[2,3] = entry_3
grid[3,3] = entry_33
grid[4,3] = entry_333

grid[1,4] = GtkLabel("Vektor b")
grid[2:4,4] = b_entry
grid[2:3,8] = button
grid[2:3,6] = result_label

set_gtk_property!(grid, :column_homogeneous, true)
set_gtk_property!(grid, :column_spacing, 5)
push!(fen, grid)
showall(fen) #fenster zeigen



#Gemacht von Akhmet Bazarbekov, 11. Januar 2023, Kasachstan. Alle Rechte und Linke sind ungeschützt