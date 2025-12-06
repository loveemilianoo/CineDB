package conexion;

import java.sql.*;

public class Conexion {
    private String url = "jdbc:postgresql://cinedb.cyvgggws0fgp.us-east-1.rds.amazonaws.com:5432/cinedb";
    private String usr = "postgres";
    private String pwd = "lpoo1234";
    
    Connection conexion = null;
    
    public Connection getConexion () throws SQLException{
        try {
            Class.forName("org.postgresql.Driver");
            conexion = DriverManager.getConnection(url, usr, pwd);
        } catch (SQLException | ClassNotFoundException e){
            throw new SQLException("Error al conetcar la base de datos "+e.toString());
        }
        return conexion;
    }
}
