package entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Boleto {
    private int idBoleto;
    private int idFuncion;
    private int idUsuario;
    private String asiento;  
    private BigDecimal precio;
    private LocalDateTime fechaCompra;
    private String estado;
    
    public Boleto() {}
    
    public Boleto(int idFuncion, int idUsuario, String asiento, BigDecimal precio) {
        this.idFuncion = idFuncion;
        this.idUsuario = idUsuario;
        this.asiento = asiento;
        this.precio = precio;
        this.fechaCompra = LocalDateTime.now();
        this.estado = "activo";
    }
    
    public int getIdBoleto() { return idBoleto; }
    public void setIdBoleto(int idBoleto) { this.idBoleto = idBoleto; }
    
    public int getIdFuncion() { return idFuncion; }
    public void setIdFuncion(int idFuncion) { this.idFuncion = idFuncion; }
    
    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }
    
    public String getAsiento() { return asiento; }
    public void setAsiento(String asiento) { this.asiento = asiento; }
    
    public BigDecimal getPrecio() { return precio; }
    public void setPrecio(BigDecimal precio) { this.precio = precio; }
    
    public LocalDateTime getFechaCompra() { return fechaCompra; }
    public void setFechaCompra(LocalDateTime fechaCompra) { this.fechaCompra = fechaCompra; }
    
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
}