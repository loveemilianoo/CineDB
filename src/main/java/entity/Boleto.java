package entity;

import java.math.BigDecimal;

public class Boleto {
    private int idBoleto;
    private int idFuncion;
    private int idAsiento;
    private int idTransaccion;
    private BigDecimal precio;
    private String tipoBoleto;
    private String estado;
    private Funcion funcion; 
    private Asiento asiento; 
    private Transaccion transaccion;
    
    public Boleto (){}
    
    public Boleto(int idBoleto, int idFuncion, int idAsiento, int idTransaccion, 
                  BigDecimal precio, String tipoBoleto, String estado) {
        this.idBoleto = idBoleto;
        this.idFuncion = idFuncion;
        this.idAsiento = idAsiento;
        this.idTransaccion = idTransaccion;
        this.precio = precio;
        this.tipoBoleto = tipoBoleto;
        this.estado = estado;
    }
    
    public int getIdBoleto() { return idBoleto; }
    public void setIdBoleto(int idBoleto) { this.idBoleto = idBoleto; }
    
    public int getIdFuncion() { return idFuncion; }
    public void setIdFuncion(int idFuncion) { this.idFuncion = idFuncion; }
    
    public int getIdAsiento() { return idAsiento; }
    public void setIdAsiento(int idAsiento) { this.idAsiento = idAsiento; }
    
    public int getIdTransaccion() { return idTransaccion; }
    public void setIdTransaccion(int idTransaccion) { this.idTransaccion = idTransaccion; }
    
    public BigDecimal getPrecio() { return precio; }
    public void setPrecio(BigDecimal precio) { this.precio = precio; }
    
    public String getTipoBoleto() { return tipoBoleto; }
    public void setTipoBoleto(String tipoBoleto) { this.tipoBoleto = tipoBoleto; }
    
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    
    public Funcion getFuncion() { return funcion; }
    public void setFuncion(Funcion funcion) { this.funcion = funcion; }
    
    public Asiento getAsiento() { return asiento; }
    public void setAsiento(Asiento asiento) { this.asiento = asiento; }
    
    public Transaccion getTransaccion() { return transaccion; }
    public void setTransaccion(Transaccion transaccion) { this.transaccion = transaccion; }
}