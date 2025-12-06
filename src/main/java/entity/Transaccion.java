package entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Transaccion {
    private int idTransaccion;
    private LocalDateTime fechaHora;
    private BigDecimal total;
    private String metodoPago;
    
    public Transaccion(){this.fechaHora = LocalDateTime.now(); }
    public Transaccion(int idTransaccion, LocalDateTime fechaHora, BigDecimal total, String metodoPago) {
        this.idTransaccion = idTransaccion;
        this.fechaHora = fechaHora != null ? fechaHora : LocalDateTime.now();
        this.total = total;
        this.metodoPago = metodoPago;
    }
    
    public int getIdTransaccion() { return idTransaccion; }
    public void setIdTransaccion(int idTransaccion) { this.idTransaccion = idTransaccion; }
    
    public LocalDateTime getFechaHora() { return fechaHora; }
    public void setFechaHora(LocalDateTime fechaHora) { this.fechaHora = fechaHora; }
    
    public BigDecimal getTotal() { return total; }
    public void setTotal(BigDecimal total) { this.total = total; }
    
    public String getMetodoPago() { return metodoPago; }
    public void setMetodoPago(String metodoPago) { this.metodoPago = metodoPago; }
}