package conexion;

import java.sql.*;

public class Main {
    public static void main(String[] args) {
        Conexion conn = new Conexion();
        try{
            Connection conexion = conn.getConexion();
            System.out.println("Conexion Exitosa");
            System.out.println("BD: "+conexion.getMetaData().getDatabaseProductName());
            conexion.close();
        } catch (SQLException e){
            System.out.println("Error "+e.toString());
        }
    }
    
}
