package entity;

import java.time.*;

public class Funcion {
    private int idFuncion;
    private int idPelicula;
    private int idSala;
    private LocalDate fecha;
    private LocalTime horaInicio;
    private Pelicula pelicula; 
    private Sala sala; 

    public Funcion() {}
    public Funcion(int idFuncion, int idPelicula, int idSala, LocalDate fecha, LocalTime horaInicio) {
        this.idFuncion = idFuncion;
        this.idPelicula = idPelicula;
        this.idSala = idSala;
        this.fecha = fecha;
        this.horaInicio = horaInicio;
    }

    public int getIdFuncion() { return idFuncion; }
    public void setIdFuncion(int idFuncion) { this.idFuncion = idFuncion; }
    
    public int getIdPelicula() { return idPelicula; }
    public void setIdPelicula(int idPelicula) { this.idPelicula = idPelicula; }
    
    public int getIdSala() { return idSala; }
    public void setIdSala(int idSala) { this.idSala = idSala; } 
    
    public LocalDate getFecha() { return fecha; }
    public void setFecha(LocalDate fecha) { this.fecha = fecha; }
    
    public LocalTime getHoraInicio() { return horaInicio; }
    public void setHoraInicio(LocalTime horaInicio) { this.horaInicio = horaInicio; }
    
    public Pelicula getPelicula() { return pelicula; }
    public void setPelicula(Pelicula pelicula) { this.pelicula = pelicula; }
    
    public Sala getSala() { return sala; }
    public void setSala(Sala sala) { this.sala = sala; }
}