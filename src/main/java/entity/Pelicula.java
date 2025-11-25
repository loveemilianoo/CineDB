package entity;

import java.time.Duration;

public class Pelicula {
    private int idPelicula;
    private String titulo;
    private Duration duracion;
    private String genero;
    private String clasificacion;
    
    public Pelicula(int idPelicula, String titulo, Duration duracion, String genero, String clasificacion) {
        this.idPelicula = idPelicula;
        this.titulo = titulo;
        this.duracion = duracion;
        this.genero = genero;
        this.clasificacion = clasificacion;
    }
    
    public int getIdPelicula() { return idPelicula; }
    public void setIdPelicula(int idPelicula) { this.idPelicula = idPelicula; }
    
    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }
    
    public Duration getDuracion() { return duracion; }
    public void setDuracion(Duration duracion) { this.duracion = duracion; }
    
    public String getGenero() { return genero; }
    public void setGenero(String genero) { this.genero = genero; }
    
    public String getClasificacion() { return clasificacion; }
    public void setClasificacion(String clasificacion) { this.clasificacion = clasificacion; }
}