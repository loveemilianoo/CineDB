package entity;

public class Sala {
    private int idSala;
    private int numeroSala;
    private int capacidad;
    
    public Sala(int idSala, int numeroSala, int capacidad) {
        this.idSala = idSala;
        this.numeroSala = numeroSala;
        this.capacidad = capacidad;
    }
    
    public int getIdSala() { return idSala; }
    public void setIdSala(int idSala) { this.idSala = idSala; }
    
    public int getNumeroSala() { return numeroSala; }
    public void setNumeroSala(int numeroSala) { this.numeroSala = numeroSala; }
    
    public int getCapacidad() { return capacidad; }
    public void setCapacidad(int capacidad) { this.capacidad = capacidad; }
}