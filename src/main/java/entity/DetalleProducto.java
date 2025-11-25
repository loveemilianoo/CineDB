package entity;

import java.math.BigDecimal;

public class DetalleProducto {
    private int idDetalle;
    private int idTransaccion;
    private int idProducto;
    private int cantidad;
    private BigDecimal subtotal;
    private Producto producto; 
    private Transaccion transaccion; 

    public DetalleProducto(int idDetalle, int idTransaccion, int idProducto, int cantidad, BigDecimal subtotal) {
        this.idDetalle = idDetalle;
        this.idTransaccion = idTransaccion;
        this.idProducto = idProducto;
        this.cantidad = cantidad;
        this.subtotal = subtotal;
    }
    
    public int getIdDetalle() { return idDetalle; }
    public void setIdDetalle(int idDetalle) { this.idDetalle = idDetalle; }
    
    public int getIdTransaccion() { return idTransaccion; }
    public void setIdTransaccion(int idTransaccion) { this.idTransaccion = idTransaccion; }
    
    public int getIdProducto() { return idProducto; }
    public void setIdProducto(int idProducto) { this.idProducto = idProducto; }
    
    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }
    
    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }
    
    public Producto getProducto() { return producto; }
    public void setProducto(Producto producto) { this.producto = producto; }
    
    public Transaccion getTransaccion() { return transaccion; }
    public void setTransaccion(Transaccion transaccion) { this.transaccion = transaccion; }
}