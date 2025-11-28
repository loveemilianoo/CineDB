package dao;

import conexion.Conexion;
import entity.Sala;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SalaDAO {
    
    public List<Sala> getSalas() {
        Conexion conn = new Conexion();
        Connection conexion = null;
        List<Sala> salas = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conexion = conn.getConexion();
            String query = "SELECT * FROM sala ORDER BY id_sala ASC";
            ps = conexion.prepareStatement(query);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Sala sala = new Sala(
                    rs.getInt("id_sala"),
                    rs.getInt("numero_sala"),
                    rs.getInt("capacidad")
                );
                salas.add(sala);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
        return salas;
    }
    
    public Sala getSalaPorId(int idSala) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        Sala sala = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conexion = conn.getConexion();
            String query = "SELECT * FROM sala WHERE id_sala = ?";
            ps = conexion.prepareStatement(query);
            ps.setInt(1, idSala);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                sala = new Sala(
                    rs.getInt("id_sala"),
                    rs.getInt("numero_sala"),
                    rs.getInt("capacidad")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
        return sala;
    }
    
    public void insertarSala(Sala sala) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        PreparedStatement ps = null;
        
        try {
            conexion = conn.getConexion();
            String query = "INSERT INTO sala (numero_sala, capacidad) VALUES (?, ?)";
            ps = conexion.prepareStatement(query);
            ps.setInt(1, sala.getNumeroSala());
            ps.setInt(2, sala.getCapacidad());
            
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
    }
    
    public void actualizarSala(Sala sala) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        PreparedStatement ps = null;
        
        try {
            conexion = conn.getConexion();
            String query = "UPDATE sala SET numero_sala = ?, capacidad = ? WHERE id_sala = ?";
            ps = conexion.prepareStatement(query);
            ps.setInt(1, sala.getNumeroSala());
            ps.setInt(2, sala.getCapacidad());
            ps.setInt(3, sala.getIdSala());
            
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
    }
    
    public void eliminarSala(int idSala) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        PreparedStatement ps = null;
        
        try {
            conexion = conn.getConexion();
            String query = "DELETE FROM sala WHERE id_sala = ?";
            ps = conexion.prepareStatement(query);
            ps.setInt(1, idSala);
            
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
    }
}