package entity;

public class Asiento {
    private int idAsiento;
    private char fila;
    private int numeroAsiento;
    private int idSala;
    private Sala sala; 
    
    public Asiento(int idAsiento, char fila, int numeroAsiento, int idSala) {
        this.idAsiento = idAsiento;
        this.fila = fila;
        this.numeroAsiento = numeroAsiento;
        this.idSala = idSala;
    }
    
    public int getIdAsiento() { return idAsiento; }
    public void setIdAsiento(int idAsiento) { this.idAsiento = idAsiento; }
    
    public char getFila() { return fila; }
    public void setFila(char fila) { this.fila = fila; }
    
    public int getNumeroAsiento() { return numeroAsiento; }
    public void setNumeroAsiento(int numeroAsiento) { this.numeroAsiento = numeroAsiento; }
    
    public int getIdSala() { return idSala; }
    public void setIdSala(int idSala) { this.idSala = idSala; }
    
    public Sala getSala() { return sala; }
    public void setSala(Sala sala) { this.sala = sala; }
}