package dao;

import conexion.Conexion;
import java.util.*;
import entity.*;
import java.sql.*;

public class BoletoDAO {
    
    public List<String> getAsientosOcupados(int idFuncion) {
        List<String> asientosOcupados = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = new Conexion().getConexion();
            String query = "SELECT asiento FROM tablas.boleto WHERE id_funcion = ? AND estado = 'activo'";
            ps = conn.prepareStatement(query);
            ps.setInt(1, idFuncion);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                asientosOcupados.add(rs.getString("asiento"));
            }
        } catch (SQLException e) {
            System.out.println("Error en getAsientosOcupados: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return asientosOcupados;
    }
    
    public Boleto insertarBoleto (Boleto boleto){
        Connection conn = null;
        ResultSet rs = null;
        PreparedStatement ps = null;
        Conexion conexion = new Conexion();
        
        try{
            conn = conexion.getConexion();
            String query = "INSERT INTO tablas.boleto (id_funcion, id_transaccion, precio, tipo_boleto, estado, asiento) "
                    + "VALUES (?,?,?,?,?,?)";
            ps = conn.prepareStatement(query);
            ps.setInt(1, boleto.getIdFuncion());
            ps.setInt(2, boleto.getIdTransaccion());
            ps.setBigDecimal(3, boleto.getPrecio());
            ps.setString(4, boleto.getTipoBoleto());
            ps.setString(5, boleto.getEstado());
            ps.setString(6, boleto.getAsiento());
            
            ps.executeUpdate();
        }catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (rs != null)rs.close();
                if (ps != null)ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
        return boleto;
    }
    
    public List<Boleto> getBoletosPorTransaccion(int idTransaccion) {
    List<Boleto> boletos = new ArrayList<>();
    ResultSet rs = null;
    Connection conn = null;
    Conexion conexion = new Conexion ();
    PreparedStatement ps = null;
            
    try {
        
        String query = "SELECT * FROM tables.boleto WHERE id_transaccion = ?";
        ps = conn.prepareStatement(query);
        ps.setInt(1, idTransaccion);
        rs = ps.executeQuery();
        
        while (rs.next()) {
            Boleto boleto = new Boleto();
            boleto.setIdBoleto(rs.getInt("id_boleto"));
            boleto.setIdFuncion(rs.getInt("id_funcion"));
            boleto.setIdTransaccion(rs.getInt("id_transaccion"));
            boleto.setPrecio(rs.getBigDecimal("precio"));
            boleto.setTipoBoleto(rs.getString("tipo_boleto"));
            boleto.setEstado(rs.getString("estado"));
            boleto.setAsiento(rs.getString("asiento"));
            
            boletos.add(boleto);
        }
    } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (rs != null)rs.close();
                if (ps != null)ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
        return boletos;
    }
}
