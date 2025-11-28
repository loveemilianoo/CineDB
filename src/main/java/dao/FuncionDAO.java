package dao;

import conexion.Conexion;
import entity.Funcion;
import java.sql.*;
import java.util.*;

public class FuncionDAO {
    public List <Funcion> getFunciones(){
        List <Funcion> funciones = new ArrayList();
        Connection conn = null;
        Conexion conexion = new Conexion();
        PreparedStatement ps= null;
        ResultSet rs = null;
        
        try {
            String query="SELECT * FROM tablas.funcion";
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
            
            ResultSetMetaData rsmd = rs.getMetaData();
            int columnas = rsmd.getColumnCount();
            while (rs.next()){
                Funcion funcion= new Funcion();
                funcion.setIdFuncion(rs.getInt("id_funcion"));
                funcion.setIdPelicula(rs.getInt("id_pelicula"));
                funcion.setIdSala(rs.getInt("id_sala"));
            }
        }catch (Exception e){
            System.out.println("Error "+e.toString());
            e.printStackTrace();
        } finally {
             try {
                 if (rs!= null) rs.close();
                 if (ps!= null) ps.close();
                 if (conn != null) conn.close();
             } catch (SQLException e){
                 System.out.println("Error al cerrar recursos "+e.toString());
             }
         } 
         return funciones;
     }
        
    
}
