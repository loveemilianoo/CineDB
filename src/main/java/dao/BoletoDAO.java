package dao;

import conexion.Conexion;
import java.util.*;
import entity.*;
import java.sql.*;

public class BoletoDAO {
     public List <Boleto> getBoletos() {
         Conexion conn = new Conexion();
         Connection conexion = null;
         List <Boleto> boletos = new ArrayList();
         PreparedStatement ps = null;
         ResultSet rs = null;
         
         try{
             conexion = conn.getConexion();
             String query = "SELECT * FROM tablas.boleto ORDER BY id_boleto ASC";
             ps= conexion.prepareStatement(query);
             rs = ps.executeQuery();
             
             ResultSetMetaData rsmd = rs.getMetaData();
             int columnas = rsmd.getColumnCount();
             
             while (rs.next()) {
                Boleto boleto = new Boleto();
                boleto.setIdBoleto(rs.getInt("id_boleto"));
                boleto.setIdFuncion(rs.getInt("id_funcion"));
                boleto.setIdAsiento(rs.getInt("id_asiento"));
                boleto.setIdTransaccion(rs.getInt("id_transaccion"));
                boleto.setPrecio(rs.getBigDecimal("precio"));
                boleto.setTipoBoleto(rs.getString("tipo_boleto"));
                boleto.setEstado(rs.getString("estado"));
                
                boletos.add(boleto);
            }
         } catch (Exception e){
             e.printStackTrace();
             System.out.println("Error "+e.toString());
         } finally {
             try {
                 if (rs!= null) rs.close();
                 if (ps!= null) ps.close();
                 if (conexion != null) conexion.close();
             } catch (SQLException e){
                 System.out.println("Error al cerrar recursos "+e.toString());
             }
         } 
         return boletos;
     }
}
