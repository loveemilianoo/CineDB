package entity;

import java.math.BigDecimal;

public class Producto {
    private int idProducto;
    private String nombre;
    private BigDecimal precioVenta;
    private int stock;

    public Producto(int idProducto, String nombre, BigDecimal precioVenta, int stock) {
        this.idProducto = idProducto;
        this.nombre = nombre;
        this.precioVenta = precioVenta;
        this.stock = stock;
    }
    
    public int getIdProducto() { return idProducto; }
    public void setIdProducto(int idProducto) { this.idProducto = idProducto; }
    
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    
    public BigDecimal getPrecioVenta() { return precioVenta; }
    public void setPrecioVenta(BigDecimal precioVenta) { this.precioVenta = precioVenta; }
    
    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }
}