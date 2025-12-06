package conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    private static final String URL = "jdbc:postgresql://cinedb.cyvgggws0fgp.us-east-1.rds.amazonaws.com:5432/cinedb";
    private static final String USER = "postgres"; // Cambia esto
    private static final String PASSWORD = "lpoo1234"; // Cambia esto
    
    public Connection getConexion() {
        Connection conn = null;
        try {
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            
            if (conn != null) {
                System.out.println("DEBUG: Conexión exitosa a la BD");
            } else {
                System.out.println("DEBUG: Conexión NULA");
            }
            
        } catch (ClassNotFoundException e) {
            System.out.println("ERROR: Driver no encontrado - " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("ERROR SQL en getConexion: " + e.getMessage());
            e.printStackTrace();
        }
        return conn;
    }
}