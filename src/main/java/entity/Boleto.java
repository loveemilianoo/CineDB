package entity;

import java.math.BigDecimal;

public class Boleto {
    private int idBoleto;
    private int idFuncion;
    private int idTransaccion;  
    private BigDecimal precio;
    private String tipoBoleto;
    private String estado;
    private String asiento;
    
    public Boleto() {}

    public Boleto(int idBoleto, int idFuncion, int idTransaccion, BigDecimal precio, String tipoBoleto, String estado, String asiento) {
        this.idBoleto = idBoleto;
        this.idFuncion = idFuncion;
        this.idTransaccion = idTransaccion;
        this.precio = precio;
        this.tipoBoleto = tipoBoleto;
        this.estado = estado;
        this.asiento = asiento;
    }
    
    public int getIdBoleto() { return idBoleto; }
    public void setIdBoleto(int idBoleto) { this.idBoleto = idBoleto; }
    
    public int getIdFuncion() { return idFuncion; }
    public void setIdFuncion(int idFuncion) { this.idFuncion = idFuncion; }
    
    public int getIdTransaccion() { return idTransaccion; }
    public void setIdTransaccion(int idTransaccion) { this.idTransaccion = idTransaccion; }
    
    public String getAsiento() { return asiento; }
    public void setAsiento(String asiento) { this.asiento = asiento; }
    
    public BigDecimal getPrecio() { return precio; }
    public void setPrecio(BigDecimal precio) { this.precio = precio; }
    
    public String getTipoBoleto() { return tipoBoleto; }
    public void setTipoBoleto(String tipoBoleto) { this.tipoBoleto = tipoBoleto; }
    
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
}